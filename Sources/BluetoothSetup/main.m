// TrackpadCompat bt-spoof — present the USB-C Magic Trackpad (0x0324) to bluetoothd as the
// Lightning Magic Trackpad 2 (0x0265) so macOS 14's built-in driver claims it over Bluetooth.
// Idea: GianMarioBen/MagicTrackPadCatalina PR #1 (Catalina). Independent implementation for the
// Sonoma cache layout. Changes only the product-ID fields of the single trackpad record.
// Never prints addresses, keys or raw values.
//
//   bt-spoof apply | restore            (root; restarts bluetoothd)
//   bt-spoof apply|restore --cache PATH  (tests only: edits PATH, no restart, root not required)
#import <Foundation/Foundation.h>
#include <sys/stat.h>
#include <unistd.h>

static NSString*const kCache=@"/Library/Bluetooth/Library/Preferences/com.apple.MobileBluetooth.devices.plist";
static const uint16_t kReal=0x0324,kSpoof=0x0265;

// Sonoma SdpCache: attrID(LE16) | type(1=uint) | size(LE16) | value(LE). 0x0201 VendorID, 0x0202 ProductID.
static NSData*SDPProduct(uint16_t pid){uint8_t b[]={0x02,0x02,0x01,0x02,0x00,pid&0xFF,pid>>8};return [NSData dataWithBytes:b length:sizeof b];}
static NSData*SDPVendor(void){uint8_t b[]={0x01,0x02,0x01,0x02,0x00,0x4C,0x00};return [NSData dataWithBytes:b length:sizeof b];}

static NSUInteger Count(NSData*hay,NSData*needle){
 NSUInteger n=0;NSRange r=NSMakeRange(0,hay.length);
 while(r.length){NSRange f=[hay rangeOfData:needle options:0 range:r];if(f.location==NSNotFound)break;n++;NSUInteger next=f.location+1;r=NSMakeRange(next,hay.length-next);}
 return n;
}
static void Stop(NSString*why){printf("STOP %s\n",why.UTF8String);exit(2);}

static BOOL Sensitive(NSString*k){NSString*l=k.lowercaseString;for(NSString*t in @[@"key",@"secret",@"token",@"irk",@"ltk"])if([l containsString:t])return YES;return NO;}
static void Walk(id v,NSMutableArray*found){
 if(![v isKindOfClass:NSDictionary.class])return;NSDictionary*d=v;
 id name=d[@"Name"];if([name isKindOfClass:NSString.class]&&[[name lowercaseString]containsString:@"trackpad"]&&d[@"HIDProductID"])[found addObject:d];
 for(NSString*k in d)if([k isKindOfClass:NSString.class]&&!Sensitive(k))Walk(d[k],found);
}

static void Convert(NSMutableDictionary*v,uint16_t src,uint16_t dst){
 NSData*hp=v[@"HIDProductID"];if(![hp isKindOfClass:NSData.class]||hp.length!=2)Stop(@"layout: HIDProductID not 2 bytes; nothing changed");
 const uint8_t*h=hp.bytes;BOOL little=(h[0]|h[1]<<8)==src,big=(h[0]<<8|h[1])==src;
 if(!little&&!big)Stop(src==kReal?@"state: already enabled; nothing changed":@"state: already original; nothing changed");
 NSData*sc=v[@"SdpCache"];
 if(![sc isKindOfClass:NSData.class]||Count(sc,SDPVendor())!=1||Count(sc,SDPProduct(src))!=1)Stop(@"layout: SdpCache vendor/product check failed; nothing changed");
 uint8_t out[2]={little?dst&0xFF:dst>>8,little?dst>>8:dst&0xFF};v[@"HIDProductID"]=[NSData dataWithBytes:out length:2];
 if([v[@"DeviceIdProduct"] isKindOfClass:NSNumber.class]&&[v[@"DeviceIdProduct"] intValue]==src)v[@"DeviceIdProduct"]=@(dst);
 NSMutableData*m=sc.mutableCopy;NSRange f=[m rangeOfData:SDPProduct(src) options:0 range:NSMakeRange(0,m.length)];
 [m replaceBytesInRange:f withBytes:SDPProduct(dst).bytes];v[@"SdpCache"]=m;
}

static NSMutableDictionary*Load(NSString*path,NSMutableDictionary**target,struct stat*st){
 if(stat(path.fileSystemRepresentation,st))Stop(@"io: cache not readable");
 NSData*data=[NSData dataWithContentsOfFile:path];if(!data)Stop(@"io: cache not readable");
 NSMutableDictionary*root=[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:nil];
 if(![root isKindOfClass:NSMutableDictionary.class])Stop(@"layout: cache is not a dictionary");
 NSMutableArray*found=[NSMutableArray array];Walk(root,found);
 if(found.count!=1)Stop([NSString stringWithFormat:@"device: expected exactly 1 trackpad record, found %lu",(unsigned long)found.count]);
 *target=found[0];return root;
}

static uint16_t CurrentPID(NSDictionary*v){NSData*hp=v[@"HIDProductID"];if(![hp isKindOfClass:NSData.class]||hp.length!=2)return 0;const uint8_t*h=hp.bytes;uint16_t le=h[0]|h[1]<<8,be=h[0]<<8|h[1];return le==kReal||le==kSpoof?le:be;}

int main(int argc,const char**argv){@autoreleasepool{
 setbuf(stdout,NULL);
 if(argc!=2&&!(argc==4&&!strcmp(argv[2],"--cache"))){fputs("usage: bt-spoof apply|restore|status [--cache PATH]\n",stderr);return 64;}
 NSString*mode=@(argv[1]);BOOL test=argc==4;NSString*path=test?@(argv[3]):kCache;
 if(!test&&geteuid()!=0)Stop(@"auth: administrator required");
 NSMutableDictionary*v=nil;struct stat st;NSMutableDictionary*root=Load(path,&v,&st);
 uint16_t before=CurrentPID(v);printf("BEFORE pid=0x%04x\n",before);
 if([mode isEqualToString:@"status"])return 0;
 BOOL apply=[mode isEqualToString:@"apply"];if(!apply&&![mode isEqualToString:@"restore"])return 64;

 // Validate and convert in memory first, so an unexpected cache never causes any write (not even the backup).
 Convert(v,apply?kReal:kSpoof,apply?kSpoof:kReal);
 NSString*backup=[path stringByAppendingString:@".tc-before-pid-spoof"];
 if(apply&&![NSFileManager.defaultManager fileExistsAtPath:backup]){
  if(![NSFileManager.defaultManager copyItemAtPath:path toPath:backup error:nil])Stop(@"io: backup failed; nothing changed");
  chmod(backup.fileSystemRepresentation,0600);printf("BACKUP %s\n",backup.UTF8String);
 }

 NSData*out=[NSPropertyListSerialization dataWithPropertyList:root format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
 if(!out)Stop(@"io: serialize failed; nothing changed");
 struct stat now;if(stat(path.fileSystemRepresentation,&now)||now.st_mtimespec.tv_sec!=st.st_mtimespec.tv_sec||now.st_mtimespec.tv_nsec!=st.st_mtimespec.tv_nsec)Stop(@"io: cache changed concurrently; nothing changed");
 NSString*tmp=[[path stringByDeletingLastPathComponent]stringByAppendingPathComponent:[NSString stringWithFormat:@".tc-pid-%d",getpid()]];
 if(![out writeToFile:tmp options:NSDataWritingAtomic error:nil])Stop(@"io: write failed; nothing changed");
 chmod(tmp.fileSystemRepresentation,st.st_mode&0777);if(!test)chown(tmp.fileSystemRepresentation,st.st_uid,st.st_gid);
 if(rename(tmp.fileSystemRepresentation,path.fileSystemRepresentation)){unlink(tmp.fileSystemRepresentation);Stop(@"io: replace failed; nothing changed");}
 printf("WROTE pid=0x%04x\n",apply?kSpoof:kReal);
 if(test)return 0;

 // SIGKILL so bluetoothd cannot flush its in-memory copy over the edit; launchd relaunches it.
 system("/usr/bin/killall -9 bluetoothd cfprefsd");
 sleep(6);
 NSMutableDictionary*after=nil;Load(path,&after,&st);uint16_t pid=CurrentPID(after);
 printf("AFTER pid=0x%04x\n",pid);
 if(pid!=(apply?kSpoof:kReal))Stop(@"verify: macOS rewrote the cache; try again after turning the trackpad off and on");
 puts(apply?"RESULT applied":"RESULT restored");
 return 0;
}}
