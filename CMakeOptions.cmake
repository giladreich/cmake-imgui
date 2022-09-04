#
# ImGui Options
#
cmake_minimum_required(VERSION 3.15)


##################################################################################################################
# OPTIONS
##################################################################################################################

option(IMGUI_STATIC_LIBRARY
  "Set to OFF to build as shared library."
  ON
)

option(IMGUI_WITH_BACKEND
  "Set to OFF to not include backend files."
  OFF
)

# TODO: Validate configurations based on the given input combination
# TODO: Add support for other platforms WIN32, SDL, GLFW, GLUT, ANDROID, APPLE, ALLEGRO5
set(IMGUI_BACKEND_PLATFORM "WIN32" CACHE STRING "")


##################################################################################################################
# DEPENDENT OPTIONS
##################################################################################################################

include(CMakeDependentOption)

cmake_dependent_option(IMGUI_BACKEND_DX9
  "Set to ON to include DX9 backend files." OFF
  "IMGUI_WITH_BACKEND" ON
)
cmake_dependent_option(IMGUI_BACKEND_DX10
  "Set to ON to include DX10 backend files." OFF
  "IMGUI_WITH_BACKEND" ON
)
cmake_dependent_option(IMGUI_BACKEND_DX11
  "Set to ON to include DX11 backend files." OFF
  "IMGUI_WITH_BACKEND" ON
)
cmake_dependent_option(IMGUI_BACKEND_DX12
  "Set to ON to include DX12 backend files." OFF
  "IMGUI_WITH_BACKEND" ON
)
