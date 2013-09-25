#import "MAGTFacadeImpl.h"

#include "git2.h"

@implementation MAGTFacadeImpl
-(const git_error*) geterr_last {
  return giterr_last();
}

-(int) git_cred_userpass_plaintext_new:(git_cred **)out_cred
                              username:(const char *)username
                              password:(const char *)password {
  return git_cred_userpass_plaintext_new(out_cred,username,password);
}

-(int) git_cred_ssh_keyfile_passphrase_new:(git_cred **)out_cred
                                  username:(const char *)username
                                 publickey:(const char *)publickey
                                privatekey:(const char *)privatekey
                                passphrase:(const char *)passphrase {
  return git_cred_ssh_keyfile_passphrase_new(out_cred,username,publickey,privatekey,passphrase);
}

-(int) git_repository_open:(git_repository**)repo
                      path:(const char*)path {
  return git_repository_open(repo,path);
}

-(int) git_remote_load:(git_remote**)remote
                  repo:(git_repository*)repo
           remote_name:(const char *)remote_name {
  return git_remote_load(remote,repo,remote_name);
}

-(void) git_remote_set_cred_acquire_cb:(git_remote*)remote
                              callback:(git_cred_acquire_cb)cred_callback
                              userdata:(void*)userdata {
  return git_remote_set_cred_acquire_cb(remote,cred_callback,userdata);
}

-(int) git_push_new:(git_push**)push 
             remote:(git_remote*)remote {
  return git_push_new(push,remote);
}

-(int) git_push_set_options:(git_push*)push
                push_options:(git_push_options*)push_options {
  return git_push_set_options(push,push_options);
}


-(int) git_push_add_refspec:(git_push*)push refspec:(const char*)refspec {
  return git_push_add_refspec(push,refspec);
}

-(int) git_push_finish:(git_push*)push {
  return git_push_finish(push);
}

-(int) git_push_unpack_ok:(git_push*)push {
  return git_push_unpack_ok(push);
}

-(int) git_push_update_tips:(git_push*)push {
  return git_push_update_tips(push);
}

-(int) git_push_status_foreach:(git_push*)push 
                      callback:( int (*)(const char *ref, const char *msg, void *data) )push_status_callback
                      userdata:(void*)userdata {
  return git_push_status_foreach(push,push_status_callback, userdata);
}

-(void) git_push_free:(git_push*)push {
  return git_push_free(push);
}


-(int) git_repository_head:(git_reference **)ref repo:(git_repository*)repo {
  return git_repository_head(ref,repo);
}

-(int) git_repository_config:(git_config**)config repo:(git_repository*)repo {
  return git_repository_config(config,repo);
}


-(int) git_config_foreach:(git_config*)config callback:(git_config_foreach_cb)callback userdata:(void*)userdata {
  return git_config_foreach(config,callback, userdata);
}

@end