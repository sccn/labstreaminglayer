LSL Tools and Applications
##########################

Besides the :doc:`device apps <supported_devices>`, many tools work with any LSL stream.
This list is not complete; to add a tool, edit this page and open a pull request on the
`labstreaminglayer repository <https://github.com/sccn/labstreaminglayer>`__.

Recording
*********

* :lslrepo:`LabRecorder` records any number of streams, with their metadata and clock
  offsets, to a single `XDF <https://github.com/sccn/xdf/wiki/Specifications>`__ file.
  It is the standard way to record LSL data.

Viewing
*******

Real-time viewers (StreamViewer, MNE-LSL, LSL Viewer, SigVisualizer, ...) and offline viewers
for XDF files are listed on the :doc:`viewers` page.

Working with recordings (XDF)
*****************************

* `pyxdf <https://github.com/xdf-modules/pyxdf>`__: load XDF files in Python.
* `xdf-Matlab <https://github.com/xdf-modules/xdf-Matlab>`__: load XDF files in MATLAB.
* `libxdf <https://github.com/xdf-modules/libxdf>`__: C++ library for loading XDF files.
* `SigViewer <https://github.com/cbrnr/sigviewer>`__ and
  `MNELAB <https://github.com/cbrnr/mnelab>`__ open XDF files directly.
* :doc:`EEGLAB <eeglab>` imports XDF files and can receive LSL streams.

Real-time processing
********************

* `MNE-LSL <https://github.com/mne-tools/mne-lsl>`__: real-time streaming and processing with
  MNE-Python, including a player that replays recordings as LSL streams.
* `Timeflux <https://github.com/timeflux/timeflux>`__: a framework for real-time
  biosignal pipelines with LSL input and output.
* :doc:`OpenViBE <ovas>` can receive and send LSL streams.

Stimulus presentation software
******************************

The following stimulus presentation systems are usable out of the box with LSL, mostly to send
event markers:

* `EventIDE <http://wiki.okazolab.com/wiki.okazolab.com/LAB-Streaming-Layer-in-EventIDE>`__
* `E-Prime 3.0 <https://github.com/PsychologySoftwareTools/eprime3-lsl-package-file/>`__
* `iMotions <https://www.imotions.com/>`__
* `Neurobehavioral Systems Presentation <https://www.neurobs.com/>`__
* PsychoPy (using LSL for Python)
* Psychtoolbox (using LSL for MATLAB)
* `Reiz <https://github.com/pyreiz/pyreiz>`__
* `Simulation and Neuroscience Application Platform (SNAP) <https://github.com/sccn/SNAP>`__
* `SuperLab X7 <https://cedrus.com/superlab/docs/lsl.htm>`__
* Unity (using `LSL4Unity <https://github.com/labstreaminglayer/LSL4Unity>`__ or liblsl C#)
* Unreal Engine (`GitHub <https://github.com/labstreaminglayer/plugin-UE4>`__,
  `Marketplace <https://www.unrealengine.com/marketplace/en-US/product/labstreaminglayer-plugin>`__)
