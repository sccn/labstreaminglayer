cmake_minimum_required(VERSION 3.5)
project(LabStreamingLayer
	VERSION 1.12.0
	LANGUAGES CXX)

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
