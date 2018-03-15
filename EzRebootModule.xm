#import "EzRebootModule.h"
#import <spawn.h>
#import <dlfcn.h>
#import <objc/runtime.h>
#import <FrontBoardServices/FBSSystemService.h>


@interface UIImage ()
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end

@implementation EzRebootModule
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]]];
}

- (UIColor *)selectedColor {
	return [UIColor blueColor];
}

- (BOOL)isSelected {
	return self.EzReboot;
}

- (void)setSelected:(BOOL)selected {
	self.EzReboot = selected;
	[super refreshState];
    [self reboot];
}

- (void)reboot {
	[[FBSSystemService sharedService] reboot];
    pid_t pid;
    int status;
    const char* args[] = {"kill", "-1", NULL};
    posix_spawn(&pid, "/usr/bin/kill", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}
@end
