cmake_minimum_required(VERSION 3.5)
project(LabStreamingLayer
	VERSION 1.12.0)

# add the liblsl build directory
add_subdirectory(LSL/liblsl)

# include LSLCMake again to set variables in the proper scope
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/LSL/liblsl")
include(LSLCMake)

# When building the whole tree, we define LSL_INSTALL_ROOT as the current directory.
# In this case we have liblsl as an actual target, so we don't need to find it.
# In all other cases, LSL_INSTALL_ROOT must be set to an actual **installed** lsl root.
set(LSL_INSTALL_ROOT ${CMAKE_CURRENT_LIST_DIR} CACHE STRING
	"LSL root directory, LSL_INSTALL_ROOT/cmake contains modules to set everything up / find liblsl" FORCE)

# include the Apps directory which defines options, which Apps will be built
# and includes their build configurations
add_subdirectory(Apps)

# Generate packages for LSL and all built apps
LSLGenerateCPackConfig()
