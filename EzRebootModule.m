#import "EzRebootModule.h"
#import <spawn.h>
#import <dlfcn.h>



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
    [self kill];
}

- (void)kill {
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle) 
        return;

    // Reset errors
    dlerror();
    typedef void (*fix_setuid_prt_t)(pid_t pid);
    fix_setuid_prt_t ptr = (fix_setuid_prt_t)dlsym(handle, "jb_oneshot_fix_setuid_now");
    
    const char *dlsym_error = dlerror();
    if (dlsym_error) 
        return;

    ptr(getpid());
    if (getuid() != 0) {
    setuid(0);
}
    pid_t pid;
    int status;
    const char* args[] = {"kill", "-1", NULL};
    posix_spawn(&pid, "/usr/bin/kill", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
}
@end
