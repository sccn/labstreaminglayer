Viewers
###########################

Over the years,  several online and offline data viewers have been developed for LSL. The list below is by no means complete. If you have created a visualizer for LSL and wish to add it to the list below, please clone this repository, edit this file and submit a pull request. Or, if there is a viewer neglected in the list below, simply post an issue with a link.

Online Viewers
**********************
A part of any LSL workbench should be a reliable way to monitor your data. Thus, sturdy, online data visualizers are essential tools. There are a number of stand-alone applications for viewing LSL data in real-time and software packages include online visualization windows.

Stand-alone online viewers:

  * `StreamViewer <https://github.com/intheon/stream_viewer>`__
  
    .. image:: ../images/stream_viewer-LineVis.gif

  * `BrainVision LSL Viewer <https://www.brainproducts.com/downloads.php?kid=40&tab=3>`__
  
    .. image:: ../images/LSL_BVLSL-Viewer.png
  
  * `MATLABViewer <https://github.com/labstreaminglayer/App-MATLABViewer>`__
    Allow visualizing, filtering and saving data in EEGLAB format. Exist as a compiled standalone application (see GitHub release) with no MATLAB installation necessary, or as an EEGLAB plugin. 

    .. image:: ../images/visstream-scroll.png
  
  * StreamViewer (old version; used to be hosted at SCCN ftp as part of the mobi_utils package: ftp://sccn.ucsd.edu/pub/software/LSL/Mobi_Utils/mobi_utils_1_1_10/)

    .. image:: ../images/streamviewer.png
  
  * :lslrepo:`SigVisualizer` (Python/PyQt5 based - From Yida Lin and Clemens Brunner)

    .. image:: ../images/SigVisualizer_demo.gif
    
  * `PlotJuggler <https://github.com/facontidavide/PlotJuggler>`__ supporst LSL streams and other data sources.
  
  * `Open Ephys <https://open-ephys.org/gui>`__ via `OpenEphysLSL-Inlet Plugin <https://github.com/labstreaminglayer/OpenEphysLSL-Inlet>`__
  
  * Older `LSL-Inlet Plugin <https://github.com/tne-lab/LSL-inlet>`__
  
  * The `python bindings <https://github.com/labstreaminglayer/liblsl-Python>`__ contain a
    `very basic visualizer <https://github.com/labstreaminglayer/liblsl-Python/blob/master/pylsl/examples/ReceiveAndPlot.py>`__.
    To start it, install pylsl and pyqtgraph and run it as
    
    :command:`python -m pylsl.examples.ReceiveAndPlot`.


Software suites/packages supporting online LSL visualization:
  * `BCI2000 <http://bci2000.org/>`__
  * `Muse LSL <https://github.com/alexandrebarachant/muse-lsl>`__
  * `Neuropype <https://www.neuropype.io/>`__
  * `OpenViBE <http://openvibe.inria.fr//>`__

Offline Viewers
**********************

The following software suites/packages support offline visualization of XDF files, the file format used by :lslrepo:`LabRecorder` to store LSL streams:
  * `EEGLAB <https://sccn.ucsd.edu/eeglab/index.php>`__
  * `Neuropype <https://www.neuropype.io/>`__
  * `MNELab <https://github.com/cbrnr/mnelab>`__
  * `MoBILAB <https://sccn.ucsd.edu/wiki/MoBILAB>`__
  * `SigViewer <https://github.com/cbrnr/sigviewer>`__
  

  
  
