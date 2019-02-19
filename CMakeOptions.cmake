#
# ImGui Options
#
cmake_minimum_required(VERSION 3.6.0)

include(CMakeDependentOption)


##################################################################################################################
# Options
##################################################################################################################
option(IMGUI_STATIC_LIBRARY  "Set to OFF to build as a DLL."                              ON)

option(IMGUI_WITH_IMPL       "Set to OFF to not include 'imgui_impl*' sources."           ON)


##################################################################################################################
# Options Dependent
##################################################################################################################
cmake_dependent_option(IMGUI_IMPL_DX9
    "Set to ON to include implementation files." OFF 
    "IMGUI_WITH_IMPL" ON
)
cmake_dependent_option(IMGUI_IMPL_DX10
    "Set to ON to include implementation files." OFF 
    "IMGUI_WITH_IMPL" ON
)
cmake_dependent_option(IMGUI_IMPL_DX11
    "Set to ON to include implementation files." OFF 
    "IMGUI_WITH_IMPL" ON
)
cmake_dependent_option(IMGUI_IMPL_DX12
    "Set to ON to include implementation files." OFF 
    "IMGUI_WITH_IMPL" ON
)

