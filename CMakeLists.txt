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

# find liblsl in the current build dir
set(LSL_INSTALL_ROOT "${CMAKE_BINARY_DIR}/LSL/liblsl")

# include the Apps directory which defines options, which Apps will be built
# and includes their build configurations
add_subdirectory(Apps)

# Generate packaging config for LSL and all built apps
LSLGenerateCPackConfig()
