# ImGui as a Library

CMake cross platform module for building [Dear ImGui](https://github.com/ocornut/imgui) as a library.


## Getting Started

```bash
git clone --recursive https://github.com/giladreich/ImGui-CMake-Installer
cd ImGui-CMake-Installer && mkdir build && cd build
cmake .. -DIMGUI_WITH_IMPL=OFF
cmake --build . --config Release --target install
```

By default it would build ImGui as a static library, but if you would like to build as a shared library(DLL), turn off `IMGUI_STATIC_LIBRARY` option when generating the project:
```bash
cmake .. -DIMGUI_WITH_IMPL=OFF -DIMGUI_STATIC_LIBRARY=OFF
```

There are few things you want to know when you build `Dear ImGui`:<br>
ImGui comes with examples that already takes care of the way people should interact with the library, i.e `imgui_impl_win32.cpp`, `imgui_impl_vulkan.cpp`, `imgui_impl_osx.mm` `imgui_impl_sdl.cpp` etc...

Basically the author of the library didn't want it to be dependent on any kind of graphic API's, therefore he expects that you'll provide your own implementation for that part(even though they're already exists in the `examples`).

That being said, before you build the library, you want to have a look at `CMakeOptions.cmake` file to see which options are available.

If you want to include one of the examples in the library build, when you generate the cmake project, you'll want to pass which graphic API you want to include in your build. Example:
```bash
cmake .. -DIMGUI_IMPL_DX11=ON
```

That would basically copy and include in your library build the following files:<br>
`imgui_impl_win32.cpp` `imgui_impl_win32.h`, `imgui_impl_dx11.cpp`, `imgui_impl_dx11.h`
and the headers will also be copied under `dist/include` directory.


### Prerequisites

If you run into any errors, please make sure you running with the correct environments(i.e `Developer Command Prompt for VS 2017`).

Another note that if you re-running cmake again with different options, make sure you remove `CMakeCache.txt` before you run cmake command again. Because the options would be cached in this file and won't refresh automatically.

## Motivation

ImGui library designed to be copied into the project internally, I therefore wanted to externalize it so I can reference to it from multiple projects instead of copying ImGui to each project. 

I also use [Conan C++ Package Manager](https://conan.io/) for building my projects and I wanted to have my [own recipe](https://github.com/giladreich/conan-imgui) for packaging ImGui with conan to make it more portable across different projects.

There is already existing project for [conan-imgui](https://github.com/bincrafters/conan-imgui), but unfortunately it only provides the library as is without the option to enable examples.

I therefore got the motivation to make this CMake module so I can manage my own conan-recipe.


## Authors

* **Gilad Reich** - *Initial work* - [giladreich](https://github.com/giladreich)

See also the list of [contributors](https://github.com/giladreich/ImGui-CMake-Installer/graphs/contributors) who participated in this project.


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

