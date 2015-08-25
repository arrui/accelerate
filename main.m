#import <Foundation/Foundation.h>


#import <fcntl.h>
#import <sys/types.h>
#import <sys/uio.h>
#import <unistd.h>
#import <sys/stat.h>
#include <math.h>


#define listCount 13
static char* list[listCount] = {
    "com.apple.DumpPanic.plist",
    "com.apple.ReportCrash.DirectoryService.plist",
    "com.apple.ReportCrash.Jetsam.plist",
    "com.apple.ReportCrash.SafetyNet.plist",
    "com.apple.ReportCrash.SimulateCrash.plist",
    "com.apple.ReportCrash.StackShot.plist",
    "com.apple.ReportCrash.plist",
    "com.apple.DumpBasebandCrash.plist",
    // "com.apple.CrashHouseKeeping.plist",
    "com.apple.aslmanager.plist",
    "com.apple.syslogd.plist",
    "com.apple.powerlog.plist",
    // "com.apple.stackshot.server.plist",
    "com.apple.chud.chum.plist",
    "com.apple.chud.pilotfish.plist",
    // "com.apple.psctl.plist",
    // "com.apple.apsd.tcpdump.en0.plist",
    // "com.apple.apsd.tcpdump.pdp_ip0.plist"
};

#pragma mark - 
int unload(){
	char cmd[256] = {0};
    for (int i = 0; i < listCount; i++) {
        sprintf(cmd,"launchctl unload /System/Library/LaunchDaemons/%s",list[i]);
        system(cmd);
        NSLog(@"%s",cmd);
    }
    return 0;
}

int load(){
    char cmd[256] = {0};
    for (int i = 0; i < listCount; i++) {
        sprintf(cmd,"launchctl load /System/Library/LaunchDaemons/%s",list[i]);
        system(cmd);
        NSLog(@"%s",cmd);
    }
    return 0;
}

int backup(){
    char cmd[256] = {0};
    sprintf(cmd,"mkdir /System/Library/LaunchDaemons/backup");
    system(cmd);
    for (int i = 0; i<listCount; i++) {
        sprintf(cmd,"mv /System/Library/LaunchDaemons/%s /System/Library/LaunchDaemons/backup/%s",list[i],list[i]);
        system(cmd);
        NSLog(@"%s",cmd);
    }
    return 0;
}

int recovery(){
    char cmd[256] = {0};
    for (int i = 0; i<listCount; i++) {
        sprintf(cmd,"mv /System/Library/LaunchDaemons/backup/%s /System/Library/LaunchDaemons/%s",list[i],list[i]);
        system(cmd);
        NSLog(@"%s",cmd);
    }
    sprintf(cmd,"rm -rf /System/Library/LaunchDaemons/backup");
    system(cmd);
    return 0;
}

int main(int argc, char* argv[]){
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    // CFRunLoopRun();
    if (argc>=2) {
        if (strcmp(argv[1],"unload")==0) {
            unload();
        }else if(strcmp(argv[1],"load")==0){
            load();
        }else if(strcmp(argv[1],"backup")==0){
            backup();
        }else if(strcmp(argv[1],"recovery")==0){
            recovery();
        }
    }else{
        NSLog(@"param error");
    }
    [pool release];
	return 0;
}
