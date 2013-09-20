#include "git2.h"
#include <iostream>
int config_callback( const git_config_entry* entry, void* userdata);
int push_status_callback(const char *ref, const char *msg, void *data);

int config_callback( const git_config_entry* entry, void* /* userdata */ ) {
  std::cout<< entry->name <<" : "<<entry->value<<" : "<<entry->level<<std::endl;
  return 0;
}

int push_status_callback(const char *ref, const char *msg, void * /* userdata */ ) {
  std::cout<<ref<<" : "<<msg<<std::endl;
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
	void *payload)
{
  std::cout<<cred<<std::endl;
  std::cout<<"URL: "<<url<<std::endl;
  std::cout<<"Username: "<<username_from_url<<std::endl;
  std::cout<<"Allowed types: "<<allowed_types<<std::endl;
  std::cout<<"Enter password: "<<std::flush;
  std::string password;
  std::cin>>password;
  std::cout<<std::endl;
  return git_cred_userpass_plaintext_new(cred, username_from_url, password.c_str());
}

int main() {
  git_repository *repo = NULL;

  std::cout<<"Opening ... "<<std::endl;
  //TODO: This leaks the cwd string.
  check_error( git_repository_open(&repo, getcwd(NULL,0)), "opening repo" );

  git_reference * ref = NULL;
  std::cout<<"Heading ... "<<std::endl;
  check_error( git_repository_head(&ref, repo), "getting head" );

  git_config * config = NULL;
  std::cout<<"Configing ... "<<std::endl;
  check_error( git_repository_config(&config, repo), "getting config" );

  git_config_foreach(config, &config_callback, NULL);


  //Lets try to push to origin...
  git_remote * remote = NULL;
  check_error( git_remote_load(&remote, repo, "origin"), "getting remote info");

  git_remote_set_cred_acquire_cb(remote, cred_callback, NULL);


  git_push * push = NULL;
  check_error( git_push_new(&push, remote), "creating push object");

  git_push_options push_options = {GIT_PUSH_OPTIONS_VERSION, 0};
  check_error( git_push_set_options(push, &push_options), "setting push options");

  char* refspec = "refs/heads/master:refs/heads/master";
  check_error( git_push_add_refspec(push, refspec), "adding refspec");
  check_error( git_push_finish(push), "finishing push" );
 
  if(! git_push_unpack_ok(push) ) {
    std::cout<<"unpach failed..."<<std::endl;
  }

  check_error( git_push_update_tips(push), "updating tips" );

  check_error( git_push_status_foreach(push, push_status_callback, NULL), "checking status");


  git_push_free(push);



}
