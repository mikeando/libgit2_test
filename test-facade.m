#include "git2.h"
#import "MAGT-Prefix.h"
#import "MAGTFacade.h"
#import "MAGTFacadeImpl.h"


int config_callback( const git_config_entry* entry, void* userdata ) {
  NSLog(@"%s : %s : %d", entry->name, entry->value, entry->level);
  return 0;
}

int push_status_callback(const char *ref, const char *msg, void * userdata ) {
  NSLog(@"%s : %s", ref, (msg?msg:("up-to-date")) );
  return 0;
}

static void check_error(int error_code, const char *action)
{
  if (!error_code)
    return;

  const git_error *error = giterr_last();

  printf("Error %d %s - %s\n", error_code, action,
       (error && error->message) ? error->message : "???");

  exit(1);
}

int cred_callback(
	git_cred **cred,
	const char *url,
	const char *username_from_url,
	unsigned int allowed_types,
	void * payload)
{
  NSLog(@"%p", cred);
  NSLog(@"URL: %s", url);
  NSLog(@"Username: %s", username_from_url);
  NSLog(@"Allowed types: %d", allowed_types);
  if(allowed_types==1) {
    NSLog(@"Enter password:");
    //Ugly to be using hardcoded length here...
    char password[40];
    int nChars = scanf("%39s", password);  
    return git_cred_userpass_plaintext_new(cred, username_from_url, password);
  } else if (allowed_types==3) {
    NSLog(@"Enter password:");
    char password[40];
    int nChars = scanf("%39s", password);  
    return git_cred_ssh_keyfile_passphrase_new(cred, username_from_url, "/Users/michaelanderson/.ssh/id_rsa.pub", "/Users/michaelanderson/.ssh/id_rsa", password);
  }
  return 1;
}

void push(id<MAGTFacade> facade, git_repository * repo, const char* remote_name) {
  //Lets try to push to origin...
  git_remote * remote = NULL;
  check_error( 
    [facade git_remote_load:&remote repo:repo remote_name:remote_name],
    "getting remote info");

  [facade git_remote_set_cred_acquire_cb:remote callback:cred_callback userdata:NULL];


  git_push * push = NULL;
  check_error(
    [facade git_push_new:&push remote:remote], 
    "creating push object");

  git_push_options push_options = {GIT_PUSH_OPTIONS_VERSION, 0};
  check_error( 
    [facade git_push_set_options:push push_options:&push_options],
    "setting push options");

  const char* refspec = "refs/heads/master:refs/heads/master";
  check_error(
    [facade git_push_add_refspec:push refspec:refspec],
    "adding refspec");
  check_error(
    [facade git_push_finish:push],
    "finishing push" );
 
  if(! [facade git_push_unpack_ok:push] ) {
    NSLog(@"unpack failed");
  }

  check_error(
    [facade git_push_update_tips:push],
    "updating tips" );

  check_error(
    [facade git_push_status_foreach:push callback:push_status_callback userdata:NULL],
    "checking status");

  [facade git_push_free:push];
}

int main() {
  
  [MAGTFacade setDefaultFacade:[[MAGTFacadeImpl alloc] init]];
  
  id<MAGTFacade> facade = [MAGTFacade defaultFacade];
  
  git_repository *repo = NULL;

  NSLog(@"Opening ...");
  //TODO: This leaks the cwd string.
  check_error( 
    [facade git_repository_open:&repo path:getcwd(NULL,0)], 
    "opening repo" );

  git_reference * ref = NULL;
  NSLog(@"Heading ... ");
  check_error( 
    [facade git_repository_head:&ref repo:repo],
    "getting head" );

  git_config * config = NULL;
  NSLog(@"Configing ... ");
  check_error(
    [facade git_repository_config:&config repo:repo], 
    "getting config" );

  [facade git_config_foreach:config callback:&config_callback userdata:NULL];


  //Lets try to push to origin...
  push(facade, repo,"origin_ssh");
  push(facade, repo,"origin");

  NSLog(@"DONE...");
  return 0;
}
