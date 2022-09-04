# ImGui as a Library

CMake cross platform module for building [Dear ImGui](https://github.com/ocornut/imgui) as a library.


## Getting Started


Clone the project:
```bash
git clone --recursive https://github.com/giladreich/cmake-imgui
cd cmake-imgui
```

Assuming the used cmake generator [supports multi-configurations](https://cmake.org/cmake/help/latest/variable/CMAKE_CONFIGURATION_TYPES.html)
(as the case with Visual Studio, Xcode, Ninja Multi-Config and others), to build and package the library, use the following commands:
```bash
mkdir build && cd build
cmake ..
cmake --build . --config debug --target install
cmake --build . --config release --target install
```

If the cmake generator doesn't support multi-configurations, when running the `cmake ..` configure command, ensure to also provide it the `-DCMAKE_BUILD_TYPE=Release` argument.

By default it will build ImGui as a static library. However it's also possible building it as a shared library:
```bash
cmake .. -DIMGUI_STATIC_LIBRARY=OFF
```

Note that ImGui also provide the option to use existing backends, where it contains platform specific implementation (`win32`, `sdl`, `glfw`, `glut`, `android`, `apple`, `allegro5`) and graphic apis (`dx{9,10,11,12}`, `vulkan`, `opengl{2,3}`, `wgpu`).

This said, when building the library, you may want to provide different combinations of flags in order to include the relevant backends in the library build:
```bash
cmake .. -DIMGUI_WITH_BACKEND=ON -DIMGUI_BACKEND_PLATFORM=WIN32 \
  -DIMGUI_BACKEND_DX11=ON
```

Note that with the DirectX case, it's also possible to build all ImGui's DirectX backends in a single build:
```bash
cmake .. -DIMGUI_WITH_BACKEND=ON -DIMGUI_BACKEND_PLATFORM=WIN32 \
  -DIMGUI_BACKEND_DX9=ON \
  -DIMGUI_BACKEND_DX10=ON \
  -DIMGUI_BACKEND_DX11=ON \
  -DIMGUI_BACKEND_DX12=ON
```

This may be useful during testing of the library, but for actual builds, ideally avoid this in order to keep a minimal build of the library.


### Package Config / Using the library

In the `examples` dir there are multiple cmake scripts to consume the previously built and installed library. The installed library comes with cmake package files. This is in particular useful to have clean integration on the consuming project (aka target), because it will inherit all the configurations needed to build an app using the library.

CMake's `package_config` will automatically generate a special target `ImGui::imgui` if found, that can be used on the consuming of package through `target_link_libraries`. Here is a minimal example app:
```cmake
cmake_minimum_required(VERSION 3.15)
project(my_imgui_app LANGUAGES CXX)
set(ImGui_DIR "${ImGui_INSTALL_DIR}/lib/cmake")
list(APPEND CMAKE_PREFIX_PATH ${ImGui_DIR})
find_package(ImGui CONFIG REQUIRED)
add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ImGui::imgui)
```


### Prerequisites

If you run into any errors, please make sure you have the correct environment (on Windows use `Developer Command Prompt for VS 2019`).

Additionally if you re-running cmake config again with different options, please make sure to delete `CMakeCache.txt` file from the build directory before running cmake command again. This is because cmake options are cached in this file.


## Motivation

ImGui library was designed to be copied directly into the project. This requires an actual compilation every time the project is rebuilt (meaning taking more time), as well as requiring configurations per file in case of using project-wide precompiled-header.

I therefore wanted to externalize it so I can consume it from multiple projects instead of having this extra maintenance.

I also use [Conan C++ Package Manager](https://conan.io/) for building my projects and I wanted to have my [own recipe](https://github.com/giladreich/conan-imgui) for packaging ImGui with conan to make it more portable across different projects.

There is already an existing project for [conan-imgui](https://github.com/bincrafters/conan-imgui), but unfortunately it only provides the library as is without the option to enable examples.


## Authors

* **Gilad Reich** - *Initial work* - [giladreich](https://github.com/giladreich)

See also the list of [contributors](https://github.com/giladreich/cmake-imgui/graphs/contributors) who participated in this project.


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
