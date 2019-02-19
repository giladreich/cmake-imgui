#
# ImGui Implementation Files
#
cmake_minimum_required(VERSION 3.6.0)


function(Init_Impl_Files HEADERS_CXX_IMPL_FILES SOURCES_CXX_IMPL_FILES)
  if (IMGUI_IMPL_DX9)
    message(STATUS "[INFO] Including Direct3D9 implementation files.")
    set(HEADERS_CXX_IMPL_FILES
      ${EXAMPLES_DIR}/imgui_impl_dx9.h
      ${EXAMPLES_DIR}/imgui_impl_win32.h
      PARENT_SCOPE
    )
    set(SOURCES_CXX_IMPL_FILES
      ${EXAMPLES_DIR}/imgui_impl_dx9.cpp
      ${EXAMPLES_DIR}/imgui_impl_win32.cpp
      PARENT_SCOPE
    )
  elseif(IMGUI_IMPL_DX10)
    message(STATUS "[INFO] Including Direct3D10 implementation files.")
    set(HEADERS_CXX_IMPL_FILES
      ${EXAMPLES_DIR}/imgui_impl_dx10.h
      ${EXAMPLES_DIR}/imgui_impl_win32.h
      PARENT_SCOPE
    )
    set(SOURCES_CXX_IMPL_FILES
      ${EXAMPLES_DIR}/imgui_impl_dx10.cpp
      ${EXAMPLES_DIR}/imgui_impl_win32.cpp
      PARENT_SCOPE
    )
  elseif(IMGUI_IMPL_DX11)
    message(STATUS "[INFO] Including Direct3D11 implementation files.")
    set(HEADERS_CXX_IMPL_FILES
      ${EXAMPLES_DIR}/imgui_impl_dx11.h
      ${EXAMPLES_DIR}/imgui_impl_win32.h
      PARENT_SCOPE
    )
    set(SOURCES_CXX_IMPL_FILES
      ${EXAMPLES_DIR}/imgui_impl_dx11.cpp
      ${EXAMPLES_DIR}/imgui_impl_win32.cpp
      PARENT_SCOPE
    )
  elseif(IMGUI_IMPL_DX12)
    message(STATUS "[INFO] Including Direct3D12 implementation files.")
    set(HEADERS_CXX_IMPL_FILES
      ${EXAMPLES_DIR}/imgui_impl_dx12.h
      ${EXAMPLES_DIR}/imgui_impl_win32.h
      PARENT_SCOPE
    )
    set(SOURCES_CXX_IMPL_FILES
      ${EXAMPLES_DIR}/imgui_impl_dx12.cpp
      ${EXAMPLES_DIR}/imgui_impl_win32.cpp
      PARENT_SCOPE
    )
  else()
    message(WARNING "[WARNING] 'IMGUI_WITH_IMPL' option is ON but no additional files were added. See file 'CMakeOptions.cmake'.")
  endif()
endfunction()
