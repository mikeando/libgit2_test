#import "MAGT-Prefix.h"
// Forward declarations of the git structures

//Ugly to need to include everything ... but for now thats easiest
#include "git2.h"

// Facade protocol that we will use in the objective-c git library instead of
// directly accessing the C API
@protocol MAGTFacade <NSObject>
-(const git_error*) geterr_last;
-(int) git_cred_userpass_plaintext_new:(git_cred **)out_cred
                              username:(const char *)username
                              password:(const char *)password;
-(int) git_cred_ssh_keyfile_passphrase_new:(git_cred **)out_cred
                                  username:(const char *)username
                                 publickey:(const char *)publickey
                                privatekey:(const char *)privatekey
                                passphrase:(const char *)passphrase;
-(int) git_repository_open:(git_repository**)repo
                      path:(const char*)path;
-(int) git_remote_load:(git_remote**)remote
                  repo:(git_repository*)repo
           remote_name:(const char *)remote_name;
-(void) git_remote_set_cred_acquire_cb:(git_remote*)remote
                              callback:(git_cred_acquire_cb)cred_callback
                              userdata:(void*)userdata;
-(int) git_push_new:(git_push**)push 
             remote:(git_remote*)remote;
-(int) git_push_set_options:(git_push*)push
                push_options:(git_push_options*)push_options;
-(int) git_push_add_refspec:(git_push*)push refspec:(const char*)refspec;
-(int) git_push_finish:(git_push*)push;
-(int) git_push_unpack_ok:(git_push*)push;

-(int) git_push_update_tips:(git_push*)push;
-(int) git_push_status_foreach:(git_push*)push 
                      callback:( int (*)(const char *ref, const char *msg, void *data) )push_status_callback
                      userdata:(void*)userdata;

-(void) git_push_free:(git_push*)push;

-(int) git_repository_head:(git_reference **)ref repo:(git_repository*)repo;
-(int) git_repository_config:(git_config**)config repo:(git_repository*)repo;
-(int) git_config_foreach:(git_config*)config callback:(git_config_foreach_cb)callback userdata:(void*)userdata;
@end

// Singleton to make using the Facade easier.
@interface MAGTFacade : NSObject
+(id<MAGTFacade>) defaultFacade;
+(void) setDefaultFacade:(id<MAGTFacade>)theme;
@end