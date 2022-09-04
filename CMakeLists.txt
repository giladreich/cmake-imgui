#
# ImGui Library
#
cmake_minimum_required(VERSION 3.15)

include(CMakeOptions.cmake)


##################################################################################################################
# PROJECT
##################################################################################################################

set(imgui_VERSION 1.88.0)

project(imgui
  VERSION ${imgui_VERSION}
  LANGUAGES CXX
  DESCRIPTION "Build ImGui as shared or static library."
  HOMEPAGE_URL "https://github.com/ocornut/imgui"
)

set(CMAKE_VERBOSE_MAKEFILE TRUE CACHE BOOL "" FORCE)

# Note that for multi-config generators, we don't need to set CMAKE_BUILD_TYPE.
# However for single-config generators, depending on the type of generator and cmake version,
# both may be null and we set CMAKE_BUILD_TYPE just in case.
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
  message(STATUS "[ImGui] CMAKE_BUILD_TYPE was not set. Defaults to Release.")
  set(CMAKE_BUILD_TYPE Release CACHE STRING "" FORCE)
endif()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(STATUS "[ImGui] Default install path: [${CMAKE_BINARY_DIR}/dist]")
  set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/dist" CACHE PATH "" FORCE)
endif()

set(IMGUI_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/imgui)
set(BACKENDS_DIR ${IMGUI_SOURCE_DIR}/backends)


##################################################################################################################
# SOURCES
##################################################################################################################

set(PUBLIC_H_FILES
  ${IMGUI_SOURCE_DIR}/imgui.h
  ${IMGUI_SOURCE_DIR}/imconfig.h
  ${IMGUI_SOURCE_DIR}/imgui_internal.h
  ${IMGUI_SOURCE_DIR}/imstb_rectpack.h
  ${IMGUI_SOURCE_DIR}/imstb_textedit.h
  ${IMGUI_SOURCE_DIR}/imstb_truetype.h
)

set(PUBLIC_CXX_FILES
  ${IMGUI_SOURCE_DIR}/imgui.cpp
  ${IMGUI_SOURCE_DIR}/imgui_draw.cpp
  ${IMGUI_SOURCE_DIR}/imgui_widgets.cpp
  ${IMGUI_SOURCE_DIR}/imgui_demo.cpp
  ${IMGUI_SOURCE_DIR}/imgui_tables.cpp
)

file(GLOB FONTS_FILES ${IMGUI_SOURCE_DIR}/misc/fonts/*.ttf)

set(IMGUI_INTERFACE_LIBS "")
if(IMGUI_WITH_BACKEND)
  if("${IMGUI_BACKEND_PLATFORM}" STREQUAL "WIN32")
    message(STATUS "[ImGui] Including backend platform: [WIN32]")
    list(APPEND PUBLIC_H_FILES ${BACKENDS_DIR}/imgui_impl_win32.h)
    list(APPEND PUBLIC_CXX_FILES ${BACKENDS_DIR}/imgui_impl_win32.cpp)
  endif()

  if(IMGUI_BACKEND_DX9)
    message(STATUS "[ImGui] Including backend api: [Direct3D9]")
    list(APPEND PUBLIC_H_FILES ${BACKENDS_DIR}/imgui_impl_dx9.h)
    list(APPEND PUBLIC_CXX_FILES ${BACKENDS_DIR}/imgui_impl_dx9.cpp)
    list(APPEND IMGUI_INTERFACE_LIBS d3d9)
  endif()
  if(IMGUI_BACKEND_DX10)
    message(STATUS "[ImGui] Including backend api: [Direct3D10]")
    list(APPEND PUBLIC_H_FILES ${BACKENDS_DIR}/imgui_impl_dx10.h)
    list(APPEND PUBLIC_CXX_FILES ${BACKENDS_DIR}/imgui_impl_dx10.cpp)
    list(APPEND IMGUI_INTERFACE_LIBS d3d10)
  endif()
  if(IMGUI_BACKEND_DX11)
    message(STATUS "[ImGui] Including backend api: [Direct3D11]")
    list(APPEND PUBLIC_H_FILES ${BACKENDS_DIR}/imgui_impl_dx11.h)
    list(APPEND PUBLIC_CXX_FILES ${BACKENDS_DIR}/imgui_impl_dx11.cpp)
    list(APPEND IMGUI_INTERFACE_LIBS d3d11)
  endif()
  if(IMGUI_BACKEND_DX12)
    message(STATUS "[ImGui] Including backend api: [Direct3D12]")
    list(APPEND PUBLIC_H_FILES ${BACKENDS_DIR}/imgui_impl_dx12.h)
    list(APPEND PUBLIC_CXX_FILES ${BACKENDS_DIR}/imgui_impl_dx12.cpp)
    list(APPEND IMGUI_INTERFACE_LIBS d3d12)
    list(APPEND IMGUI_INTERFACE_LIBS dxgi)
    # list(APPEND IMGUI_INTERFACE_LIBS d3dcompiler)
  endif()
endif()

set(PROJECT_FILES
  ${PUBLIC_H_FILES}
  ${PUBLIC_CXX_FILES}
  ${FONTS_FILES}
)


##################################################################################################################
# IDE REPRESENTATION
##################################################################################################################

# Groups CMake pre-defined projects:
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
source_group("" FILES ${PUBLIC_H_FILES})
source_group("" FILES ${PUBLIC_CXX_FILES})
source_group("\\Fonts" FILES ${FONTS_FILES})


##################################################################################################################
# TARGET
##################################################################################################################

if(IMGUI_STATIC_LIBRARY)
  message(STATUS "[ImGui] Building STATIC library")
  add_library(${PROJECT_NAME} STATIC ${PROJECT_FILES})
else()
  message(STATUS "[ImGui] Building SHARED library")
  add_library(${PROJECT_NAME} SHARED ${PROJECT_FILES})
endif()
add_library(ImGui::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${IMGUI_SOURCE_DIR}>
    $<BUILD_INTERFACE:${BACKENDS_DIR}>
    $<INSTALL_INTERFACE:include> # ${CMAKE_INSTALL_PREFIX}/include
)
target_link_libraries(${PROJECT_NAME} INTERFACE ${IMGUI_INTERFACE_LIBS})

if(IMGUI_BACKEND_DX12)
  target_link_libraries(${PROJECT_NAME} PRIVATE d3d12 dxgi)
  target_compile_definitions(${PROJECT_NAME} PRIVATE ImTextureID=ImU64)
endif()

target_compile_options(${PROJECT_NAME}
  PUBLIC
    $<$<CXX_COMPILER_ID:MSVC>:$<$<CONFIG:Debug>:/MTd>>
    $<$<CXX_COMPILER_ID:MSVC>:$<$<CONFIG:MinSizeRel>:/MT>>
    $<$<CXX_COMPILER_ID:MSVC>:$<$<CONFIG:Release>:/MT>>
    $<$<CXX_COMPILER_ID:MSVC>:$<$<CONFIG:RelWithDebInfo>:/MTd>>
)

if(MSVC)
  if(IMGUI_STATIC_LIBRARY)
    set_property(TARGET ${PROJECT_NAME} PROPERTY WINDOWS_EXPORT_ALL_SYMBOLS OFF)
  else()
    set_property(TARGET ${PROJECT_NAME} PROPERTY WINDOWS_EXPORT_ALL_SYMBOLS ON)
  endif()
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES
    DEBUG_POSTFIX "${STATIC_POSTFIX}d"
    RELEASE_POSTFIX "${STATIC_POSTFIX}"
    MINSIZEREL_POSTFIX "${STATIC_POSTFIX}mr"
    RELWITHDEBINFO_POSTFIX "${STATIC_POSTFIX}rd"
)


##################################################################################################################
# INSTALL
##################################################################################################################

set(CMAKE_PACKAGE_NAME "ImGui")
string(TOLOWER ${CMAKE_PACKAGE_NAME} CMAKE_PACKAGE_NAME_LOWER)
set(TARGETS_EXPORT_NAME "${CMAKE_PACKAGE_NAME}Targets")

install(TARGETS ${PROJECT_NAME}
  EXPORT ${TARGETS_EXPORT_NAME}
)
install(FILES ${PUBLIC_H_FILES}
  DESTINATION include/imgui
)
install(FILES ${FONTS_FILES}
  DESTINATION misc/fonts
)

if(MSVC)
  if(IMGUI_STATIC_LIBRARY)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>/$<TARGET_FILE_BASE_NAME:${PROJECT_NAME}>.pdb
      DESTINATION lib
      CONFIGURATIONS Debug OR RelWithDebInfo
    )
  else()
    install(FILES $<TARGET_PDB_FILE:${PROJECT_NAME}>
      DESTINATION bin
      CONFIGURATIONS Debug OR RelWithDebInfo
    )
  endif()
endif()


##################################################################################################################
# PACKAGE
##################################################################################################################

include(CMakePackageConfigHelpers)

set(GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(CMAKE_FILES_INSTALL_DIR "lib/cmake/${CMAKE_PACKAGE_NAME_LOWER}")
set(VERSION_FILE "${GENERATED_DIR}/${CMAKE_PACKAGE_NAME}ConfigVersion.cmake")
set(CONFIG_FILE "${GENERATED_DIR}/${CMAKE_PACKAGE_NAME}Config.cmake")

file(WRITE "${CONFIG_FILE}.in"
"@PACKAGE_INIT@

include(\"\${CMAKE_CURRENT_LIST_DIR}/${TARGETS_EXPORT_NAME}.cmake\")
")

write_basic_package_version_file(${VERSION_FILE} VERSION ${imgui_VERSION} COMPATIBILITY AnyNewerVersion)
configure_package_config_file("${CONFIG_FILE}.in" ${CONFIG_FILE} INSTALL_DESTINATION ${CMAKE_FILES_INSTALL_DIR})

install(EXPORT ${TARGETS_EXPORT_NAME}
  NAMESPACE ${CMAKE_PACKAGE_NAME}::
  DESTINATION ${CMAKE_FILES_INSTALL_DIR}
)
install(FILES ${VERSION_FILE} ${CONFIG_FILE}
  DESTINATION ${CMAKE_FILES_INSTALL_DIR}
)
