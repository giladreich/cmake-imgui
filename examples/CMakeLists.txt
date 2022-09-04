#
# ImGui Example App
# MSVC app using Direct3D9. Similar approach should follow on other platforms.
#
cmake_minimum_required(VERSION 3.15)


##################################################################################################################
# PROJECT
##################################################################################################################

project(imgui_app
  LANGUAGES CXX
  DESCRIPTION "ImGui app."
)

set(CMAKE_VERBOSE_MAKEFILE TRUE CACHE BOOL "" FORCE)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(STATUS "[ImGui] Default install path: [${CMAKE_BINARY_DIR}/dist]")
  set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/dist" CACHE PATH "" FORCE)
endif()

add_subdirectory(win32_dx9)
add_subdirectory(win32_dx10)
add_subdirectory(win32_dx11)
add_subdirectory(win32_dx12)
