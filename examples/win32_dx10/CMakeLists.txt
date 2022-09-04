#
# ImGui Example App
# MSVC app using Direct3D10. Similar approach should follow on other platforms.
#
cmake_minimum_required(VERSION 3.15)


##################################################################################################################
# PROJECT
##################################################################################################################

project(imgui_app_win32_dx10
  LANGUAGES CXX
  DESCRIPTION "ImGui app."
)

set(CMAKE_VERBOSE_MAKEFILE TRUE)

get_filename_component(PROJECT_ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}" PATH)
get_filename_component(PROJECT_ROOT_DIR "${PROJECT_ROOT_DIR}" PATH)
set(ImGui_INSTALL_DIR "${PROJECT_ROOT_DIR}/build/dist")

set(ImGui_DIR "${ImGui_INSTALL_DIR}/lib/cmake")
list(APPEND CMAKE_PREFIX_PATH ${ImGui_DIR})
find_package(ImGui CONFIG REQUIRED)

# CMake's regex engine is almost unusable. Therefore we use native's shell to replace the include headers
# to match with the wrapped library directory structure.
set(MAIN_CXX "${PROJECT_ROOT_DIR}/imgui/examples/example_win32_directx10/main.cpp")
set(MAIN_CXX_OUT "${CMAKE_CURRENT_BINARY_DIR}/main.cpp")
execute_process(COMMAND powershell
  (Get-Content -Path ${MAIN_CXX})
  -replace '\(include\\s+\)\"\(imgui.*\)\"', '$1<imgui/$2>' | Out-File ${MAIN_CXX_OUT}
)

add_executable(${PROJECT_NAME} ${MAIN_CXX_OUT})
target_link_libraries(${PROJECT_NAME} PRIVATE ImGui::imgui)

# This allows to debug when compiling ImGui as shared library
string(REPLACE "/" "\\" VS_DEBUGGER_ENV ${ImGui_INSTALL_DIR})
set_target_properties(${PROJECT_NAME} PROPERTIES VS_DEBUGGER_ENVIRONMENT "PATH=${VS_DEBUGGER_ENV}\\bin;$(PATH)")

install(TARGETS ${PROJECT_NAME})
