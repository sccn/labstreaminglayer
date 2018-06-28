cmake_minimum_required(VERSION 3.5)

# Minimum C++ standard, apps can request more features with
# target_compile_features()
set(CMAKE_CXX_STANDARD 11)

option(LSLAPPS_Benchmarks       "Build benchmark apps"              OFF)
option(LSLAPPS_EGIAmpServer     "Build the EGI (Geodesic) app"      OFF)
option(LSLAPPS_Examples         "Build example apps"                OFF)
option(LSLAPPS_LabRecorder      "Build the recorder app"            OFF)
option(LSLAPPS_XDFBrowser       "Build the XDFBrowser app"          OFF)
option(LSLAPPS_Wiimote          "Build the Wiimote app"             OFF)
option(LSLAPPS_OpenVR           "Build the OpenVR app"              OFF)

# Windows-only apps
if(WIN32)
    option(LSLAPPS_BrainAmp     "Build the BrainAmp app"            OFF)
    option(LSLAPPS_LiveAmp      "Build the LiveAmp app"             OFF)
    option(LSLAPPS_Emotiv       "Build the Emotiv app"              OFF)
    option(LSLAPPS_gNEEDaccess  "Build the g.Tec NEEDaccess app"    OFF)
endif()

# add all Apps the user wants to build
if(LSLAPPS_Benchmarks)
	add_subdirectory(Benchmarks)
endif()

if(LSLAPPS_EGIAmpServer)
	add_subdirectory(EGIAmpServer)
endif()

if(LSLAPPS_Examples)
    add_subdirectory(Examples)
endif()

if(LSLAPPS_LabRecorder)
    add_subdirectory(LabRecorder)
endif()

if(LSLAPPS_XDFBrowser)
    add_subdirectory(XDFBrowser)
endif()

if(LSLAPPS_Wiimote)
    add_subdirectory(Wiimote)
endif()

if(LSLAPPS_OpenVR)
    add_subdirectory(OpenVR)
endif()

if(LSLAPPS_BrainAmp)
    add_subdirectory(BrainAmpSeries)
    add_subdirectory(BrainProducts/BrainVisionRDA)
    #add_subdirectory(BrainProducts/BrainAmpImpedance)
endif()

if(LSLAPPS_LiveAmp)
    add_subdirectory(BrainProducts/LiveAmp)
endif()

if(LSLAPPS_Emotiv)
    add_subdirectory(emotiv)
endif()

if(LSLAPPS_gNEEDaccess)
    add_subdirectory(g.Tec/g.NEEDaccess)
endif()
