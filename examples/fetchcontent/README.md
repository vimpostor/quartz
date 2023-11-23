# FetchContent

This example demonstrates how to build against Quartz with **cmake FetchContent**.

In essence, the relevant part is to clone the repository with **FetchContent** and then to link the cmake target of your own project against `quartz` and `quartzplugin`:

```cmake
include(FetchContent)
# Please replace origin/master with a proper constant git commit hash, to avoid breaking changes hitting you immediately
FetchContent_Declare(quartz GIT_REPOSITORY https://github.com/vimpostor/quartz.git GIT_TAG origin/master)
FetchContent_MakeAvailable(quartz)
target_link_libraries("${PROJECT_NAME}" PRIVATE quartz quartzplugin)
```

After that Quartz should be fully available, that is it can be imported in QML with `import Quartz` and the C++ files can be included with `#include "Quartz/quartz.hpp"` and will be automatically linked.
