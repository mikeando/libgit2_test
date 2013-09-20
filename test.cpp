#include "git2.h"
#include <iostream>

int config_callback( const git_config_entry* entry, void* userdata) {
  std::cout<< entry->name <<" : "<<entry->value<<" : "<<entry->level<<std::endl;
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

int main() {
  git_repository *repo = NULL;

  check_error( git_repository_open(&repo, "."), "opening repo" );

  git_reference * ref = NULL;
  check_error( git_repository_head(&ref, repo), "getting head" );

  git_config * config = NULL;
  check_error( git_repository_config(&config, repo), "getting config" );

  git_config_foreach(config, &config_callback, NULL);

}
