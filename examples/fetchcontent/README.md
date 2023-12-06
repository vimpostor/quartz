# FetchContent

This example demonstrates how to build against Quartz with **cmake FetchContent**.

In essence, the relevant part is to clone the repository with **FetchContent** and then to link quartz to your own project's target with `quartz_link()`:

```cmake
include(FetchContent)
# Please replace origin/master with a proper constant git commit hash, to avoid breaking changes hitting you immediately
FetchContent_Declare(quartz GIT_REPOSITORY https://github.com/vimpostor/quartz.git GIT_TAG origin/master)
FetchContent_MakeAvailable(quartz)

quartz_link("${PROJECT_NAME}")
```

After that Quartz should be fully available, that is it can be imported in QML with `import Quartz` and the C++ files can be included with `#include "quartz/quartz.hpp"` and will be automatically linked.

## Icons

If you want icons to be bundled, pass the `ICONS` parameter to the `quartz_link()` call, which must be followed by icon names of [Material design symbols](https://fonts.google.com/icons) as additional parameters. Following is an example that bundles two icons, which will be accessible under the `:/svg/` [qrc](https://doc.qt.io/qt-6/resources.html) directory.
Note that quartz will automatically add all internally needed icons to the list that you pass via `ICONS`. If you want to bundle all icons, add the `ALL_ICONS` parameter instead. If you only want to bundle internally needed icons, use `INTERNAL_ICONS` instead.
If neither of these three parameters are used, no icons will be bundled, which may result in some QML UI components not working correctly.

```cmake
quartz_link("${PROJECT_NAME}" ICONS "info" "settings") # bundle two icons, plus quartz-internal icons
quartz_link("${PROJECT_NAME}" ALL_ICONS) # bundle all icons
quartz_link("${PROJECT_NAME}" INTERNAL_ICONS) # bundle quartz-internal icons only
quartz_link("${PROJECT_NAME}") # bundle no icons
```

The reason why it is allowed to bundle no icons, is because this allows users who do not need any icons to skip the download of the SVG icons during the cmake configure stage.
