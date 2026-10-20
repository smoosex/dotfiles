#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>

int main(void) {
    @autoreleasepool {
        NSMutableArray *displays = [NSMutableArray array];
        CGFloat desktopTop = NSMaxY(NSScreen.screens.firstObject.frame);
        for (NSScreen *screen in NSScreen.screens) {
            CGDirectDisplayID displayID = [screen.deviceDescription[@"NSScreenNumber"] unsignedIntValue];
            CFUUIDRef uuid = CGDisplayCreateUUIDFromDisplayID(displayID);
            NSString *uuidString = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
            CFRelease(uuid);
            CGFloat notchWidth = 0;
            if (@available(macOS 12.0, *)) {
                if (screen.safeAreaInsets.top > 0) {
                    notchWidth = NSMinX(screen.auxiliaryTopRightArea) - NSMaxX(screen.auxiliaryTopLeftArea);
                }
            }
            [displays addObject:@{
                @"uuid": uuidString,
                @"top": @(desktopTop - NSMaxY(screen.frame)),
                @"notch_width": @(notchWidth)
            }];
        }
        NSData *json = [NSJSONSerialization dataWithJSONObject:displays options:0 error:nil];
        fwrite(json.bytes, 1, json.length, stdout);
    }
    return 0;
}
