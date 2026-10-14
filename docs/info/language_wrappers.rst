Language Bindings
#################

liblsl is a C library with a C++ wrapper (both documented in the
:liblsl:`liblsl documentation <index.html>`). Other languages use it through bindings.
The *official* bindings are maintained under the
`labstreaminglayer GitHub organization <https://github.com/labstreaminglayer>`__.
*Community* bindings are maintained by others; they are listed here because we know of them,
not as an endorsement, and their completeness and upkeep vary (the year of the last change is
given as a hint). To add one, edit this page and open a pull request.

Official
********

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - Language
     - Project
     - Notes
   * - C / C++
     - `liblsl <https://github.com/sccn/liblsl>`__
     - The library itself: ``lsl_c.h`` and the header-only ``lsl_cpp.h``.
   * - Python
     - `pylsl <https://github.com/labstreaminglayer/pylsl>`__
     - ``pip install pylsl``; ctypes wrapper around liblsl.
   * - MATLAB
     - `liblsl-Matlab <https://github.com/labstreaminglayer/liblsl-Matlab>`__
     - MEX wrappers.
   * - C#
     - `liblsl-Csharp <https://github.com/labstreaminglayer/liblsl-Csharp>`__
     - A single file (``LSL.cs``) using P/Invoke; you provide ``lsl.dll``.
   * - Unity
     - `LSL4Unity <https://github.com/labstreaminglayer/LSL4Unity>`__
     - Unity package with the C# binding and the native plugin.
   * - Unreal Engine
     - `plugin-UE4 <https://github.com/labstreaminglayer/plugin-UE4>`__
     - Also on the Unreal Marketplace.
   * - Java
     - `liblsl-Java <https://github.com/labstreaminglayer/liblsl-Java>`__
     - JNA wrapper; also used on Android.
   * - Rust
     - `liblsl-rust <https://github.com/labstreaminglayer/liblsl-rust>`__
     - crates ``lsl`` / ``lsl-sys`` (last published 2020).
   * - Android
     - `liblsl-Android <https://github.com/labstreaminglayer/liblsl-Android>`__
     - Older Android Studio build of liblsl and the Java binding (2020). For new apps, build liblsl
       from your app's ``CMakeLists.txt`` (see :liblsl:`Building liblsl <guide/building.html#android>`).
   * - Other (SWIG)
     - `liblsl-Generic <https://github.com/labstreaminglayer/liblsl-Generic>`__
     - SWIG interface files for generating further bindings (2018).

Community
*********

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - Language
     - Project
     - Notes
   * - Python
     - `MNE-LSL <https://github.com/mne-tools/mne-lsl>`__
     - ``pip install mne-lsl``; has its own low-level binding (``mne_lsl.lsl``) plus real-time tools for MNE-Python.
   * - C#
     - `SharpLSL <https://github.com/SharpLSL/SharpLSL>`__
     - NuGet ``SharpLSL``; cross-platform. (2026)
   * - C# (Bonsai)
     - `emotional-cities/lsl <https://github.com/emotional-cities/lsl>`__
     - NuGet ``EmotionalCities.Lsl``. (2023)
   * - C# (vvvv)
     - `LSL4VVVV <https://github.com/jfrey-xx/LSL4VVVV>`__
     - For vvvv gamma. (2022)
   * - C#
     - `Diademics LibLSL <https://github.com/Diademics-Pty-Ltd/LibLSL>`__
     - (2022)
   * - Dart / Flutter
     - `liblsl.dart <https://github.com/NexusDynamic/liblsl.dart>`__
     - `pub.dev liblsl <https://pub.dev/packages/liblsl>`__; full C API via FFI, builds liblsl from source. (2026)
   * - Dart / Flutter
     - `Bridging-Labs <https://github.com/dtu-digital-health/Bridging-Labs>`__
     - pub.dev ``lsl_bindings`` / ``lsl_flutter``. (2025)
   * - JavaScript (Capacitor, Cordova)
     - `capacitor-lsl <https://github.com/Mindfield-Biosystems-Ltd/capacitor-lsl>`__,
       `cordova-plugin-lsl <https://github.com/Mindfield-Biosystems-Ltd/cordova-plugin-lsl>`__
     - Outlets only, for Android and iOS apps. (2026)
   * - Node.js
     - `node-labstreaminglayer <https://github.com/EdgeBCI/LabStreamingLayer>`__
     - npm ``node-labstreaminglayer``. (2025)
   * - Node.js
     - `@neurodevs/node-lsl <https://github.com/neurodevs/node-lsl>`__
     - Outlets only. (2026)
   * - Node.js
     - `lsl.js <https://github.com/JuananMtez/lsl.js>`__, `node-lsl <https://github.com/urish/node-lsl>`__
     - Older; partial API. (2023, 2019)
   * - Julia
     - `LSL.jl <https://github.com/samuelpowell/LSL.jl>`__
     - Julia package ``LSL``; liblsl from ``liblsl_jll``. (2026)
   * - LabVIEW
     - `liblsl-LabVIEW <https://github.com/maltesen/liblsl-LabVIEW>`__
     - (2019)
   * - Pure Data
     - `PdLSL <https://github.com/dmedine/PdLSL>`__
     - Inlet and outlet externals. (2019)
   * - openFrameworks
     - `ofxLSL <https://github.com/moostrik/ofxLSL>`__
     - Incomplete. (2022)
   * - Swift
     - `LabStreamingLayer <https://github.com/CodingMeSwiftly/LabStreamingLayer>`__
     - Minimal wrapper. (2020)
   * - Odin
     - `lslodin <https://github.com/matthiasdold/lslodin>`__
     - Experimental, macOS. (2026)

Reimplementations
*****************

These implement the LSL protocol themselves instead of using liblsl. They may differ from liblsl
in behavior and compatibility; check how they are tested before relying on them.

* Rust: `labstream <https://github.com/rednayan/labstream>`__ (exports liblsl's C API),
  `rlsl <https://github.com/eugenehp/rlsl>`__ (C API, Python bindings and a WebSocket bridge)
* Swift: `SwiftLSL <https://github.com/PhysiologyWorkbench/SwiftLSL>`__ (receiving only)
