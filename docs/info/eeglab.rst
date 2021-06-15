EEGLAB integration
####

Streaming and saving LSL data in EEGLAB
---------------------
You may use the 
`App-MATLABViewer <https://github.com/labstreaminglayer/App-MATLABViewer/>`__
which is an EEGLAB plugin to directly stream data into EEGLAB and save it as an EEGLAB dataset.

Importing XDF data in EEGLAB
---------------------
The LabRecorder application is the main application to save LSL data in the XDF format. XDF format can be imported in 2 ways in EEGLAB.

* xdfimport plugin: This plugin allow import single EEG XDF streams and synchronized LSL marker stream (if any).

* mobilab plugin: This plugin allow import multiple EEG XDF streams (and synchronized LSL marker stream), resample them to the same sampling frequency if necessary.

This 
`Youtube video <https://www.youtube.com/watch?v=tDDkrmv3ZKE>`__
contains more details about integration between EEGLAB and LSL.
