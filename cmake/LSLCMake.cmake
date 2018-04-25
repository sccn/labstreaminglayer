# Common functions and settings for LSL

message(STATUS "Included LSL CMake helpers, rev. 2")

# set build type and default install dir if not done already
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type" FORCE)
endif()
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
	set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/build/install" CACHE PATH
		"Where to put redistributable binaries" FORCE)
	message(WARNING "CMAKE_INSTALL_PREFIX default initialized to ${CMAKE_INSTALL_PREFIX}")
endif()

# Try to find the labstreaminglayer library and enable
# the imported target LSL::lsl
#
# Use it with
# target_link_libraries(your_target_app PRIVATE LSL::lsl)

if(TARGET lsl)
	add_library(LSL::lsl ALIAS lsl)
	message(STATUS "Found target lsl in current build tree")
else()
	message(STATUS "Trying to find package LSL")
	list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR})
	find_package(LSL REQUIRED)
endif()

# Generate folders for IDE targets (e.g., VisualStudio solutions)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Set runtime path, i.e. where shared libs are searched relative to the exe
if(APPLE AND NOT LSL_UNIXFOLDERS)
	list(APPEND CMAKE_INSTALL_RPATH "@executable_path/../LSL/lib")
	list(APPEND CMAKE_INSTALL_RPATH "@executable_path/")
elseif(UNIX AND NOT LSL_UNIXFOLDERS)
	list(APPEND CMAKE_INSTALL_RPATH "\$ORIGIN/../LSL/lib:\$ORIGIN")
endif()

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "limited configs" FORCE)

# Qt5
set(CMAKE_INCLUDE_CURRENT_DIR ON) # Because the ui_mainwindow.h file.
# Enable automatic compilation of .cpp->.moc, xy.ui->ui_xy.h and resource files
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORC ON)

# Boost
#SET(Boost_DEBUG OFF) #Switch this and next to ON for help debugging Boost problems.
#SET(Boost_DETAILED_FAILURE_MSG ON)
if(WIN32)
	set(Boost_USE_STATIC_LIBS ON)
endif()

IF(MSVC)
	# Disable boost auto linking.
	add_definitions(-DBOOST_ALL_NO_LIB )
endif()

# LSL functions, mostly for Apps

# installs additional files (configuration etc.)
function(installLSLAuxFiles target)
	get_target_property(is_bundle ${target} MACOSX_BUNDLE)
	set(destdir ${PROJECT_NAME})
	if(LSL_UNIXFOLDERS)
		set(destdir bin/)
	elseif(is_bundle AND APPLE)
		set(destdir ${destdir}/${target}.app/Contents/MacOS)
	endif()
	if("${ARGV1}" STREQUAL "directory")
		install(DIRECTORY ${ARGV2} DESTINATION ${destdir} COMPONENT "LSL${PROJECT_NAME}")
	else()
		install(FILES ${ARGN} DESTINATION ${destdir} COMPONENT "LSL${PROJECT_NAME}")
	endif()
endfunction()

# installLSLApp: adds the specified target to the install list
#
# there are two install types for different use cases
# Windows users mostly want a folder per app that contains
# everything needed to run the app, whereas on Linux,
# OS X (homebrew) and Conda the libraries are installed
# separately to save space, ease upgrading and distribution
function(installLSLApp target)
	set(CPACK_COMPONENT_${PROJECT_NAME}_DEPENDS liblsl PARENT_SCOPE)
	if(LSL_UNIXFOLDERS)
		install(TARGETS ${target}
			COMPONENT "LSL${PROJECT_NAME}"
			RUNTIME DESTINATION bin
			LIBRARY DESTINATION lib
		)
	else()
		installLSLAppSingleFolder(${target})
	endif()
endfunction()

# installLSLAppSingleFolder: installs the app its folder and copies needed libraries
# 
# when calling make install / ninja install the executable is installed to
# CMAKE_INSTALL_PREFIX/PROJECT_NAME/TARGET_NAME
# e.g. C:/LSL/BrainAmpSeries/BrainAmpSeries.exe
function(installLSLAppSingleFolder target)
	install(TARGETS ${target}
		COMPONENT "LSL${PROJECT_NAME}"
		BUNDLE DESTINATION ${PROJECT_NAME}
		RUNTIME DESTINATION ${PROJECT_NAME}
		LIBRARY DESTINATION ${PROJECT_NAME}/lib
	)
	set(appbin "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}/${target}${CMAKE_EXECUTABLE_SUFFIX}")
	
	# Copy lsl library for WIN32 or MacOS.
	# On Mac, dylib is only needed for macdeployqt and for non bundles when not using system liblsl.
	# Copy anyway, and fixup_bundle can deal with the dylib already being present.
	if(WIN32 OR APPLE)
		installLSLAuxFiles(${target} $<TARGET_FILE:LSL::lsl>)
	endif()

	# do we need to install with Qt5?
	get_target_property(TARGET_LIBRARIES ${target} LINK_LIBRARIES)
	if(";${TARGET_LIBRARIES}" MATCHES ";Qt5::")
		# TODO: add the executable name to a list we feed to *deployqt later on?
		# https://gitlab.pluribusgames.com/games/apitrace/blob/master/gui/CMakeLists.txt#L121-174
		get_target_property(QT_QMAKE_EXECUTABLE Qt5::qmake IMPORTED_LOCATION)
		execute_process(COMMAND ${QT_QMAKE_EXECUTABLE} -query QT_VERSION OUTPUT_VARIABLE QT_VERSION)
		get_filename_component(QT_BIN_DIR "${QT_QMAKE_EXECUTABLE}" DIRECTORY)
		if(WIN32)
			find_program (QT_DEPLOYQT_EXECUTABLE windeployqt HINTS "${QT_BIN_DIR}")
			if (QT_DEPLOYQT_EXECUTABLE)
				file (TO_NATIVE_PATH "${QT_BIN_DIR}" QT_BIN_DIR_NATIVE)
				# It's safer to use `\` separators in the Path, but we need to escape them
				string (REPLACE "\\" "\\\\" QT_BIN_DIR_NATIVE "${QT_BIN_DIR_NATIVE}")
				
				# windeployqt needs VCINSTALLDIR to copy MSVC Runtime files, but it's
				# usually not define with MSBuild builds.
				if ($ENV{VCINSTALLDIR})
					set (VCINSTALLDIR "$ENV{VCINSTALLDIR}")
				elseif (MSVC11)
					set (VCINSTALLDIR "$ENV{VS110COMNTOOLS}../../VC")
				elseif (MSVC12)
					set (VCINSTALLDIR "\$ENV{VS120COMNTOOLS}/../../VC")
				elseif (MSVC14)
					set (VCINSTALLDIR "\$ENV{VS140COMNTOOLS}/../../VC")
				else ()
					message (FATAL_ERROR "Unsupported MSVC version ${MSVC_VERSION}")
				endif ()
				file(TO_CMAKE_PATH ${VCINSTALLDIR} VCINSTALLDIR)
				if(QT_VERSION VERSION_LESS 5.3.0)
					set(QT_DEPLOYQT_FLAGS --no-translations --no-system-d3d-compiler)
				else()
					set(QT_DEPLOYQT_FLAGS --no-translations --no-system-d3d-compiler --no-opengl-sw --no-compiler-runtime)
				endif()
				install (CODE "
					message (STATUS \"Running Qt Deploy Tool...\")
					if (CMAKE_INSTALL_CONFIG_NAME STREQUAL \"Debug\")
						list (APPEND QT_DEPLOYQT_FLAGS --debug)
					else ()
						list (APPEND QT_DEPLOYQT_FLAGS --release)
					endif ()
					execute_process(COMMAND
						\"${CMAKE_COMMAND}\" -E env
						\"Path=${QT_BIN_DIR_NATIVE};\$ENV{SystemRoot}\\\\System32;\$ENV{SystemRoot}\"
						\"VCINSTALLDIR=${VCINSTALLDIR}\"
						\"${QT_DEPLOYQT_EXECUTABLE}\"
						${QT_DEPLOYQT_FLAGS}
						\"${appbin}\"
					)
				")
			endif(QT_DEPLOYQT_EXECUTABLE)
		
		elseif(APPLE)
			# It should be enough to call fixup_bundle (see below),
			# but this fails to install qt plugins (cocoa).
			# Use macdeployqt instead (but this is bad at grabbing lsl dylib, so we did that above)
			find_program (QT_DEPLOYQT_EXECUTABLE macdeployqt HINTS "${QT_BIN_DIR}")
			if(QT_DEPLOYQT_EXECUTABLE)
				set(QT_DEPLOYQT_FLAGS "-verbose=1")  # Adding -libpath=${CMAKE_INSTALL_PREFIX}/LSL/lib seems to do nothing, maybe deprecated
				install(CODE "
					message(STATUS \"Running Qt Deploy Tool...\")
					#list(APPEND QT_DEPLOYQT_FLAGS -dmg)
					if(CMAKE_INSTALL_CONFIG_NAME STREQUAL \"Debug\")
					    list(APPEND QT_DEPLOYQT_FLAGS -use-debug-libs)
					endif()
					execute_process(COMMAND
						\"${QT_DEPLOYQT_EXECUTABLE}\"
						\"${appbin}.app\"
						${QT_DEPLOYQT_FLAGS}
					)
				")
			endif(QT_DEPLOYQT_EXECUTABLE)
		endif(WIN32)
	elseif(APPLE)
		# fixup_bundle appears to be broken for Qt apps. Use only for non-Qt.
		get_target_property(target_is_bundle ${target} MACOSX_BUNDLE)
		if(target_is_bundle)
			install(CODE "
				include(BundleUtilities)
				set(BU_CHMOD_BUNDLE_ITEMS ON)
				fixup_bundle(
					${appbin}.app
					\"\"
					\"${CMAKE_INSTALL_PREFIX}/LSL/lib\"
				)
				"
				COMPONENT Runtime
			)
		endif(target_is_bundle)
	endif()
endfunction()


# default paths, versions and magic to guess it on windows
# guess default paths for Windows / VC
set(LATEST_QT_VERSION "5.10.1")

# Boost autoconfig:
# Original author: Ryan Pavlik <ryan@sensics.com> <ryan.pavlik@gmail.com
# Released with the same license as needed to integrate into CMake.
# Modified by Chadwick Boulay Jan 2018

if (CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(lslplatform 64)
else()
	set(lslplatform 32)
endif()

if(WIN32 AND MSVC)
	# see https://cmake.org/cmake/help/latest/variable/MSVC_VERSION.html
	if(MSVC_VERSION EQUAL 1500)
		set(VCYEAR 2008)
	elseif(MSVC_VERSION EQUAL 1600)
		set(VCYEAR 2010)
	elseif(MSVC_VERSION EQUAL 1700)
		set(VCYEAR 2012)
	elseif(MSVC_VERSION EQUAL 1800)
		set(VCYEAR 2013)
		set(_vs_ver 12.0)
	elseif(MSVC_VERSION EQUAL 1900)
		set(VCYEAR 2015)
		set(_vs_ver 14.0)
	elseif(MSVC_VERSION GREATER 1910 AND MSVC_VERSION LESS 1919)
		set(VCYEAR 2017)
		set(_vs_ver 14.1)
	else()
		message(WARNING "You're using an untested Visual C++ compiler (MSVC_VERSION: ${MSVC_VERSION}).")
	endif()
	if(NOT _vs_ver)
		message(WARNING "You're using an untested Visual C++ compiler.")
	endif()

	if(NOT Qt5_DIR)
		set(Qt5_DIR "C:/Qt/${LATEST_QT_VERSION}/msvc${VCYEAR}_${lslplatform}/lib/cmake/Qt5")
		message(STATUS "You didn't specify a Qt5_DIR. I'm guessing it's ${Qt5_DIR}.")
		message(STATUS "If you are building Apps that require Qt and if this is wrong then please add the correct dir with -DQt5_DIR=/path/to/Qt5/lib/cmake/Qt5")
	endif()

	if((NOT BOOST_ROOT) AND (NOT Boost_INCLUDE_DIR) AND (NOT Boost_LIBRARY_DIR))
		message(STATUS "Attempting to find Boost, whether or not you need it.")
		set(_libdir "lib${lslplatform}-msvc-${_vs_ver}")
		set(_haslibs)
		if(EXISTS "c:/local")
			file(GLOB _possibilities "c:/local/boost*")
			list(REVERSE _possibilities)
			foreach(DIR ${_possibilities})
				if(EXISTS "${DIR}/${_libdir}")
					list(APPEND _haslibs "${DIR}")
				endif()
			endforeach()
			if(_haslibs)
				list(APPEND CMAKE_PREFIX_PATH ${_haslibs})
				find_package(Boost QUIET)
				if(Boost_FOUND AND NOT Boost_LIBRARY_DIR)
					set(BOOST_ROOT "${Boost_INCLUDE_DIR}" CACHE PATH "")
					set(BOOST_LIBRARYDIR "${Boost_INCLUDE_DIR}/${_libdir}" CACHE PATH "")
				endif()
			endif()
		endif()
	endif()
	if(NOT BOOST_ROOT)
		message(STATUS "Did not find Boost. If you need it then set BOOST_ROOT and/or BOOST_LIBRARYDIR")
	endif()
endif()

macro(LSLGenerateCPackConfig)
	# CPack configuration
	set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)
	set(CPACK_PACKAGE_NAME ${PROJECT_NAME})
	set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
	set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
	set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
	set(SYSTEM_PROCESSOR ${CMAKE_SYSTEM_PROCESSOR})

	if(APPLE)
		set(CPACK_GENERATOR "TBZ2")
	elseif(WIN32)
		set(CPACK_GENERATOR "ZIP")
	elseif(UNIX)
		set(CPACK_GENERATOR DEB)
		set(CPACK_SET_DESTDIR 1)
		set(CPACK_INSTALL_PREFIX "/usr")
		set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Tristan Stenner <ttstenner@gmail.com>")
		set(CPACK_DEBIAN_ENABLE_COMPONENT_DEPENDS 1)
		set(CPACK_DEB_COMPONENT_INSTALL ON)
		set(CPACK_DEBIAN_PACKAGE_PRIORITY optional)

		# include distribution name (e.g. trusty or xenial) in the file name
		# only works on CMake>=3.6, does nothing on CMake<3.6
		find_program(LSB_RELEASE lsb_release)
		execute_process(COMMAND ${LSB_RELEASE} -cs
			OUTPUT_VARIABLE LSB_RELEASE_CODENAME
			OUTPUT_STRIP_TRAILING_WHITESPACE
		)
		set(CPACK_DEBIAN_FILE_NAME "DEB-DEFAULT")
		set(CPACK_DEBIAN_PACKAGE_RELEASE ${LSB_RELEASE_CODENAME})
	endif()
	include(CPack)
endmacro()
