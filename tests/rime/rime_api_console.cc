#include "rime_api.h"
#include <dlfcn.h>
#include <cstdio>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <string>

int main(int argc, char** argv) {
  if (argc < 4) return 2;
  for (const char* plugin : {"lua", "predict", "octagram"}) {
    const std::string path = std::string("/Library/Input Methods/Squirrel.app/Contents/Frameworks/rime-plugins/librime-") + plugin + ".dylib";
    if (!dlopen(path.c_str(), RTLD_NOW | RTLD_GLOBAL)) {
      std::cerr << dlerror() << '\n';
      return 3;
    }
  }
  RimeApi* api = rime_get_api();
  const char* modules[] = {"default", "lua", "predict", "octagram", nullptr};
  RIME_STRUCT(RimeTraits, traits);
  traits.user_data_dir = argv[1];
  traits.shared_data_dir = argv[1];
  traits.app_name = "rime.globtest";
  traits.modules = modules;
  traits.log_dir = argv[1];
  traits.min_log_level = 2;
  api->setup(&traits);
  api->initialize(&traits);
  const auto session = api->create_session();
  if (!session || !api->select_schema(session, argv[2])) {
    std::cerr << "Cannot select schema\n";
    api->finalize();
    return 4;
  }
  api->set_option(session, "ascii_mode", False);
  for (int n = 3; n < argc; ++n) {
    api->clear_composition(session);
    bool handled = true;
    for (const unsigned char* c = reinterpret_cast<unsigned char*>(argv[n]); *c; ++c) {
      if (!api->process_key(session, *c, 0)) handled = false;
    }
    const char* raw = api->get_input(session);
    std::cout << "{\"query\":" << std::quoted(argv[n])
              << ",\"input\":" << std::quoted(raw ? raw : "")
              << ",\"handled\":" << (handled ? "true" : "false") << ",\"candidates\":[";
    RimeCandidateListIterator it = {};
    bool comma = false;
    if (api->candidate_list_begin(session, &it)) {
      while (api->candidate_list_next(&it)) {
        if (comma) std::cout << ',';
        comma = true;
        std::cout << std::quoted(it.candidate.text);
        if (it.index >= 999) break;
      }
      api->candidate_list_end(&it);
    }
    std::cout << "]}\n";
  }
  api->destroy_session(session);
  api->finalize();
  return 0;
}
