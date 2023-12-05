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

After that Quartz should be fully available, that is it can be imported in QML with `import Quartz` and the C++ files can be included with `#include "quartz/quartz.hpp"` and will be automatically linked.

## Icons

If you want icons to be bundled, call the `quartz_bundle_icons()` cmake function, the first parameter is your cmake `TARGET` and after that you may pass icon names of [Material design symbols](https://fonts.google.com/icons) as additional parameters. If no trailing arguments are passed, **all** icons will be bundled. Here is an example that bundles two icons, which will be accessible under the `:/svg/` [qrc](https://doc.qt.io/qt-6/resources.html) directory:

```cmake
quartz_bundle_icons("${PROJECT_NAME}" "info" "settings")
```
