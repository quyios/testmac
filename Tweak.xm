#import <Foundation/Foundation.h>
#import <objc/message.h>
static NSString *MSRandomMAC(void){uint8_t b[6];arc4random_buf(b,6);b[0]=(b[0]&0xfc)|2;return [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",b[0],b[1],b[2],b[3],b[4],b[5]];}
static id MSSharedInstance(Class c){SEL s=NSSelectorFromString(@"sharedInstance");if(![c respondsToSelector:s])return nil;return ((id(*)(id,SEL))objc_msgSend)((id)c,s);}
static void MSApply(NSString *ssid,NSString *mac){id w=MSSharedInstance(NSClassFromString(@"WifiManager"));SEL s=NSSelectorFromString(@"submitMacAddress:ssid:");if(w&&[w respondsToSelector:s])((void(*)(id,SEL,id,id))objc_msgSend)(w,s,mac,ssid);}
static void MSApplyConfigured(void) {
    NSUserDefaults *d = [[NSUserDefaults alloc] initWithSuiteName:@"com.amywhile.macspoof"];
    NSDictionary *cfg = [d objectForKey:@"NetworksConfig"];
    [cfg enumerateKeysAndObjectsUsingBlock:^(NSString *ssid, NSDictionary *entry, BOOL *stop) {
        MSApply(ssid, [entry objectForKey:@"Address"]);
    }];
}
static void MSRandomize(void){
    NSUserDefaults*d=[[NSUserDefaults alloc]initWithSuiteName:@"com.amywhile.macspoof"];
    NSDictionary *old=[d objectForKey:@"NetworksConfig"];
    NSMutableDictionary*cfg=[old mutableCopy];
    NSMutableDictionary *updated=[NSMutableDictionary dictionary];
    [old enumerateKeysAndObjectsUsingBlock:^(NSString*ssid,NSDictionary*e,BOOL*stop){
        NSString*m=MSRandomMAC(); NSMutableDictionary*u=[e mutableCopy]?:[NSMutableDictionary dictionary];
        [u setObject:m forKey:@"Address"]; [updated setObject:u forKey:ssid]; MSApply(ssid,m);
    }];
    [d setObject:updated.count ? updated : cfg forKey:@"NetworksConfig"]; [d synchronize];
}
static void MSCallback(CFNotificationCenterRef c,void*o,CFStringRef n,const void*x,CFDictionaryRef u){
    NSString *name = (__bridge NSString *)n;
    if ([name isEqualToString:@"com.amywhile.macspoof.randomize"]) MSRandomize();
    else if ([name isEqualToString:@"com.amywhile.macspoof.update"] || [name isEqualToString:@"com.amywhile.macspoof.force"]) MSApplyConfigured();
}
%ctor{if(![[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Preferences"])return;CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,MSCallback,NULL,NULL,CFNotificationSuspensionBehaviorDeliverImmediately);}
