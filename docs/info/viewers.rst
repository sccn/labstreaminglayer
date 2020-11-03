Viewers
###########################

Over the years,  several online and offline data viewers have been developed for LSL. The list below is by no means complete. If you have created a visualizer for LSL and wish to add it to the list below, please clone this repository, edit this file and submit a pull request. Or, if there is a viewer neglected in the list below, simply post an issue with a link.

Online Viewers
**********************
A part of any LSL workbench should be a reliable way to monitor your data. Thus, sturdy, online data visualizers are essential tools. There are a number of stand-alone applications for viewing LSL data in real-time and software packages include online visualization windows.

Stand-alone online viewers:
  * `BrainVision LSL Viewer <https://www.brainproducts.com/downloads.php?kid=40&tab=3>`__
  
  .. image:: ../images/LSL_BVLSL-Viewer.png
  
  * :lslrepo:`MATLABViewer` (part of LSL distribution)
  
  .. image:: ../images/visstream-adapted.png
  
  * StreamViewer (available from SCCN ftp as part of the mobi_utils package: ftp://sccn.ucsd.edu/pub/software/LSL/Mobi_Utils/mobi_utils_1_1_10/)
  
  .. image:: ../images/streamviewer.png
  
  * :lslrepo:`SigVisualizer` (Python/PyQt5 based - From Yida Lin and Clemens Brunner)
  
  .. image:: ../images/SigVisualizer_demo.gif

The `python bindings <https://github.com/labstreaminglayer/liblsl-Python>`__
contain a `very basic visualizer <https://github.com/labstreaminglayer/liblsl-Python/blob/master/pylsl/examples/ReceiveAndPlot.py>`__.
To start it, install pylsl and pyqtgraph and run it as
:command:`python -m pylsl.examples.ReceiveAndPlot`.

Software suites/packages supporting online LSL visualization:
  * `BCI2000 <http://bci2000.org/>`__
  * `Muse LSL <https://github.com/alexandrebarachant/muse-lsl>`__
  * `Neuropype <https://www.neuropype.io/>`__
  * `OpenViBE <http://openvibe.inria.fr//>`__

Offline Viewers
**********************

The following software suites/packages supporting offline LSL visualization:
  * `EEGLAB <https://sccn.ucsd.edu/eeglab/index.php>`__
  * `MNELab <https://github.com/cbrnr/mnelab>`__
  * `MoBILAB <https://sccn.ucsd.edu/wiki/MoBILAB>`__
  * `SigViewer <https://github.com/cbrnr/sigviewer>`__
  

  
  
