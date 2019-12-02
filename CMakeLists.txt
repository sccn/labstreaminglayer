cmake_minimum_required(VERSION 3.12)
project(LabStreamingLayer
	VERSION 1.13.0
	LANGUAGES CXX)

if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/LSL/liblsl/CMakeLists.txt")
	message(FATAL_ERROR "LSL/liblsl doesn't contain CMakeLists.txt.
	Did you check out the liblsl submodule? For more information, see see
	https://github.com/sccn/labstreaminglayer/blob/master/doc/Working-with-the-repository.md")
endif()
# add the liblsl build directory
add_subdirectory(LSL/liblsl)

# Most apps have common requirements: find Boost / Qt, create an installation
# target, etc. The LSLCMake helper module contains sensible settings and
# functions to make the app developer life easier.
# LSLCMake was already included in LSL/liblsl, but we include it again so the
# variables are in this scope (instead of just the LSL/liblsl scope)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/LSL/liblsl")
include(LSLCMake)

# include the Apps directory which defines options, which Apps will be built
# and includes their build configurations
add_subdirectory(Apps)

# Generate packaging config for LSL and all built apps
LSLGenerateCPackConfig()
