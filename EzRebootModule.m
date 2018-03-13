#import "EzRebootModule.h"
#import <spawn.h>



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
    pid_t pid;
    int status;
    const char* args[] = {"reboot", NULL};
    posix_spawn(&pid, "/usr/bin/reboot", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}
@end
