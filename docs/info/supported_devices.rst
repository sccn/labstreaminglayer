Supported Devices and Tools
###########################

**For device applications and tools hosted on GitHub, please make sure to read the respective repository's README and to check the release page for downloads.**

The lab streaming layer was originally developed to facilitate human-subject experiments that involve multi-modal data acquisition, including brain dynamics (primarily EEG), physiology (EOG, EMG, heart rate, respiration, skin conductance, etc.), as well as behavioral data (motion capture, eye tracking, touch interaction, facial expressions, etc.) and finally environmental and program state (for example, event markers). There exists already many devices and applications with LSL integration already provided. This page lists the integrations of which we are aware, but does not serve as an endorsement and most integrations are untested by the LSL team.

If you are looking for LSL support for a device that is not in the list, try specialized google searches (e.g., combine your device name, "LSL", and "GitHub"). If that fails to find a pre-existing solution, then you will need to get a device SDK to access the live signal stream and write your own application to push it to LSL -- this can be quite simple depending on the SDK.

Supported Biosignal Hardware
****************************
The majority of EEG systems on the market are currently compatible with LSL.


The following systems are supported by programs included in the LSL distribution (untested systems marked with a (u)):
  * `ABM B-Alert X4/X10/X24 wireless <https://github.com/labstreaminglayer/App-BAlertAthenaCLI>`__
  * `BioSemi Active II Mk1 and Mk2 <https://github.com/labstreaminglayer/App-BioSemi>`__
  * `Blackrock Cerebus/NSP <https://github.com/labstreaminglayer/App-BlackrockTimestamps>`__ (timestamps only)
  * `Cognionics dry/wireless <https://github.com/labstreaminglayer/App-Cognionics>`__
  * `EGI AmpServer <https://github.com/labstreaminglayer/App-EGIAmpServer>`__
  * `Enobio dry/wireless <https://github.com/labstreaminglayer/App-Enobio>`__ (u) (please use vendor-provided section)
  * `g.Tec g.USBamp <https://github.com/labstreaminglayer/App-g.Tec/tree/master/g.USBamp>`__ (buggy at high sampling rates)
  * `g.Tec g.NEEDaccess <https://github.com/labstreaminglayer/App-g.Tec/tree/master/g.NEEDaccess>`__ (including g.USBamp, g.HIamp, g.Nautilus)
  * `MINDO dry/wireless <https://github.com/labstreaminglayer/App-MINDO>`__
  * `Neuroscan Synamp II and Synamp Wireless <https://github.com/labstreaminglayer/App-Neuroscan>`__ (u)
  * `Neuroscan Acquire <https://github.com/labstreaminglayer/App-NeuroscanAcquire>`__ (u)
  * `Wearable Sensing <https://github.com/labstreaminglayer/App-WearableSensing>`__

The following devices support LSL via vendor-provided software:
  * `ANT Neuro eego sports <https://www.ant-neuro.com/products/eego_sports/eego-software>`__
  * `ANT Neuro eego sports <https://www.ant-neuro.com/products/eego_mylab/software_features>`__
  * `Bitbrain EEG & Biosignals platform <https://www.bitbrain.com/neurotechnology-products/software/programming-tools>`__
  * `Bittium NeurOne Tesla <https://www.bittium.com/medical/support>`__
  * `BrainAccess by NEUROtechnology <https://www.brainaccess.ai>`__
  * `Brain Products actiCHamp/actiCHamp Plus <https://github.com/brain-products/LSL-actiCHamp>`__
  * `Brain Products BrainAmp series <https://github.com/brain-products/LSL-BrainAmpSeries>`__
  * `Brain Products LiveAmp <https://github.com/brain-products/LSL-LiveAmp/>`__
  * `BrainVision RDA client <https://github.com/brain-products/LSL-BrainVisionRDA>`__
  * `Cognionics (all headsets) <http://www.cognionics.com/>`__
  * `EB Neuro BE Plus LTM <http://www.ebneuro.biz/en/neurology/ebneuro/galileo-suite/be-plus-ltm>`__
  * `Emotiv Brainware (e.g. EPOC) via EmotivPRO <https://github.com/Emotiv/labstreaminglayer>`__
  * `IDUN Guardian via provided Python scripts <https://sdk-docs.idunguardian.com/examples.html#stream-data-to-lsl>`__
  * `mBrainTrain SMARTING <http://www.mbraintrain.com/smarting/>`__
  * neuroelectrics `(Enobio <http://www.neuroelectrics.com/products/enobio/>`__, `StarStim <https://www.neuroelectrics.com/solutions/starstim>`__) via `NIC2 <https://www.neuroelectrics.com/solution/software-integrations/nic2>`__.
  * `Mentalab Explore <https://github.com/Mentalab-hub/explorepy>`__
  * `Neuracle NeuroHub <https://github.com/neuracle/Neuracle.LSLSample>`__
  * `OpenBCI (all headsets) <http://docs.openbci.com/software/06-labstreaminglayer>`__
  * `Starcat HackEEG Shield for Arduino <https://www.starcat.io/>`__
  * `TMSi APEX <https://www.tmsi.artinis.com/tmsi-python-library>`__
  * `TMSi SAGA <https://www.tmsi.artinis.com/tmsi-python-library>`__
  
The following are some of the devices we know about that support LSL natively through third party software, but there are many others we don't know about:
  * `Bittium Faros <https://www.bittium.com/medical/cardiology>`__      
      * `Faros Streamer <https://github.com/bwrc/faros-streamer>`__
      * `Faros Streamer 2 <https://github.com/bwrc/faros-streamer-2>`__
  * `InteraXon Muse <http://www.choosemuse.com/>`__
      * :doc:`MU-01 - Muse - Released 2014 Example with Matlab <matlab_example_with_muse>`
      * `Muse (MU-02 2016) and Muse 2 (MU-03 2018) <https://github.com/alexandrebarachant/muse-lsl>`__
      * `Muse 2016, Muse 2, Muse S <https://github.com/kowalej/BlueMuse>`__


The following devices support LSL natively without any additional software:
  * `Foc.us EEG Dev Kit <https://foc.us/eeg>`__
  * `Neurosity Notion <https://neurosity.co/>`__
  * `NeuroBehavioralSystems LabStreamer <https://www.neurobs.com/menu_presentation/menu_hardware/labstreamer>`__


The following systems are also supported by a separate program, the :doc:`OpenViBE acquisition server <ovas>`, but note however that there is `an outstanding issue that prevents streams acquired with OpenViBE from synchronizing with other LSL streams <http://openvibe.inria.fr/tracker/view.php?id=197>`__:
  * ANT Neuro ASALAB EEG
  * Brain Products QuickAmp, V-Amp, and BrainAmp series
  * CTF/VSM (u)
  * EGI NetAmp (u)
  * g.USBamp
  * Emotiv EPOC
  * Micromed SD LTM
  * MindMedia NeXus32
  * Mitsar EEG 202 (u)
  * OpenEEG ModularEEG and MonolithEEG
  * TMSi Porti32 and Refa32

Supported fNIRS Hardware
************************
The following devices support LSL natively without any additional software:
  * `Artinis Brite Family <https://www.artinis.com/brite-family>`__,  `Portalite <https://www.artinis.com/portalite>`__  `PortaMon <https://www.artinis.com/portamon>`__, `OxyMon <https://www.artinis.com/oxymon>`__ and `Artinis NIRS-EEG package <https://www.artinis.com/nirs-eeg-package>`__  via `OxySoft <https://www.artinis.com/oxysoft>`__ and `Brite Connect <https://www.artinis.com/brite-connect>`__
  * `Cortivision PHOTON CAP <https://www.cortivision.com/products/photon/>`__
  * `GowerLabs LUMO <https://www.gowerlabs.co.uk/lumo>`__
  * `NIRx NIRScout <https://nirx.net/nirscout>`__ and `NIRSport 2 <https://nirx.net/nirsport>`__ via `Aurora <https://nirx.net/software>`__ and `Turbo-Satori <https://nirx.net/turbosatori>`__

Supported Electrophysiological Hardware
****************************************
Various devices with ECG and/or EMG sensors are supported. Some of these have non-electrophys sensors as well (i.e., GSR, Respiration, Temperature, Accelerometer, etc.) 
  * `bitalino (using LSL for Python) <https://github.com/fsuarezj/bitalino_lsl>`__ (wearables and various sensors)
  * `CGX (Cognionics) AIM Physiological Monitor <https://www.cgxsystems.com/auxiliary-input-module-gen2>`__ (ExG/Respiration/GSR/SPo2/Temp)
  * `Heart Rate Service bands <https://github.com/abcsds/HRBand-LSL>`__ (Many bluetooth HR bands such as the Polar H10)  
  * `Polar H10 ECG <https://github.com/markspan/PolarBLE?tab=readme-ov-file>`__  
  * `Shimmer Examples (using LSL for C#) <https://github.com/ShimmerEngineering/liblsl-Csharp/tree/shimmer_dev/examples/SendData>`__ (ECG/EMG/GSR/Accelerometer/Gyroscope/Magnetometer/PPG/Temperature/etc)
  * `Shimmer Examples (using LSL for Java) <https://github.com/ShimmerEngineering/liblsl-Java/tree/shimmer_dev/src/examples>`__ (ECG/EMG/GSR/Accelerometer/Gyroscope/Magnetometer/PPG/Temperature/etc)  
  * `TMSi SPIRE EMG <https://www.tmsi.artinis.com/tmsi-python-library>`__
  * `Zephyr BioHarness <https://github.com/labstreaminglayer/App-Zephyr>`__ (ECG/Respiration/Accelerometer)

Supported Eye Tracking Hardware
*******************************
Several eye tracking systems are currently supported by LSL and included in the distribution (untested systems marked with a (u)):
  * `7invensun Eye Tracker <https://github.com/FishBones-DIY/App-7invensun>`__
  * Custom 2-camera eye trackers (with some hacking)
  * `EyeLogic <https://github.com/EyeLogicSolutions/EyeLogic-LSL>`__
  * :lslrepo:`EyeTechDS - VT3-Mini <EyeTechDS>`
  * Eye Tribe Tracker Pro
  * `HTC Vive Eye <https://github.com/mit-ll/Signal-Acquisition-Modules-for-Lab-Streaming-Layer>`__  
  * :lslrepo:`Pupil-Labs <PupilLabs>`
  * :lslrepo:`SMI iViewX <SMIEyetracker>`
  * :lslrepo:`SMI Eye Tracking Glasses <SMIEyetracker>`
  * SR Research Eyelink (very basic)
  * Tobii Eye trackers
      * :lslrepo:`Tobii Pro <TobiiPro>`
      * `Tobii Glasses 3 <https://github.com/tobiipro/Tobii.Glasses3.SDK/releases>`__
      * :lslrepo:`Tobii StreamEngine (consumer devices) <TobiiStreamEngine>`
  

Supported Human Interface Hardware
**********************************
A wide range of Windows-compatible input hardware is supported by LSL and included with the distribution:
  * :lslrepo:`Input devices (keyboards, trackballs, presenters, etc.) <Input>`
  * :lslrepo:`DirectX-compatible joysticks, wheels <GameController>`
  * :lslrepo:`Gamepads (e.g. XBox Controller) - cross-platform <Gamepad>`
  * :lslrepo:`Nintendo Wiimote and official expansions <Wiimote>`

Supported Motion Capture Hardware
*********************************
Several motion-capture systems are currently supported by LSL. The ones we know of are:
  * :lslrepo:`AMTI force plates with serial I/O <AMTIForcePlate>`
  * :lslrepo:`PhaseSpace`
  * :lslrepo:`Microsoft Kinect <KinectMocap>`
  * :lslrepo:`NaturalPoint OptiTrack <OptiTrack>` (some versions)
  * :lslrepo:`OpenVR`
  * `Qualisys <https://github.com/qualisys/qualisys_lsl_app>`__
  * `Vicon <https://gitlab.com/vicon-pupil-data-parser/vajkonstrim>`__ (LSL support unclear - check with authors)
  * `Xsens <https://github.com/Torres-SMIL/xsens_labstreaminglayer_link>`__
  * `UltraLeap Leap Motion <https://github.com/labstreaminglayer/LSL-LeapMotion>`__

Supported Multimedia Hardware
*****************************
Support for standard Windows-compatible multimedia hardware is included:
  * DirectShow-compatible video hardware
  * :lslrepo:`Qt-compatible audio input <AudioCapture>`
  * `mbtCameraLSL (Android) <https://play.google.com/store/apps/details?id=com.mbraintrain.mbtcameralsl&hl=en>`__
  * `TimeShot (Windows multi-camera capture) <https://github.com/markspan/TimeShot>`__

Supported Stimulation Hardware
******************************
The following stimulation devices (TMS, TDCS / TACS) have LSL support:
  * `Soterix Medical MXN-33 Transcranial Electrical Stimulator <https://soterixmedical.com/research/hd/mxn-33>`__

Supported Stimulus Presentation Software
****************************************
The following stimulus presentations systems are usable out of the box with LSL:
  * `EventIDE <http://wiki.okazolab.com/wiki.okazolab.com/LAB-Streaming-Layer-in-EventIDE>`__
  * `E-Prime 3.0 <https://github.com/PsychologySoftwareTools/eprime3-lsl-package-file/>`__
  * `iMotions <https://www.imotions.com/>`__
  * `Neurobehavioral Systems Presentation <https://www.neurobs.com/>`__
  * Psychopy (using LSL for Python)
  * PsychToolbox (using LSL for MATLAB)
  * `Reiz <https://github.com/pyreiz/pyreiz>`__
  * `Simulation and Neuroscience Application Platform (SNAP) <https://github.com/sccn/SNAP>`__
  * Unity (using `LSL4Unity <https://github.com/labstreaminglayer/LSL4Unity>`_ or liblsl C#)
  * Unreal Engine (`Marketplace <https://www.unrealengine.com/marketplace/en-US/product/labstreaminglayer-plugin>`__, `GitHub <https://github.com/labstreaminglayer/plugin-UE4>`__)

Miscellaneous Hardware
**********************
The following miscellaneous hardware is supported:
  * :lslrepo:`Generic serial port <SerialPort>`
  * :lslrepo:`Measurement Computing DAQ <MeasurementComputing>`
  * `biosignalsplux sensors using OpenSignals <https://www.biosignalsplux.com/index.php/software/apis>`__
  * :lslrepo:`Vernier Go Direct sensors <vernier>`
  * :lslrepo:`Nonin Xpod PPG  <nonin>`
  * `Tyromotion Amadeo Robot <https://github.com/pyreiz/ctrl-tyromotion>`__
