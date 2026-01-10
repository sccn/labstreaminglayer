:orphan:

.. _lslbuildenv:

LSL build environment
=====================

liblsl and most apps use :ref:`buildenvcmake` and C++.
Most apps also use Qt for a graphical user interface.

Recommended compiler toolchain
------------------------------

Download the newest toolchain you can get.

The following platforms are the supported targets for liblsl.
Most apps require newer compilers.

========================= ======        ===========
OS / Compiler             Supported Versions
------------------------- -------------------------
Name                      Min           Max
========================= ======        ===========
Windows                   10            11
Visual C++                2019          2022
macOS                     10.15         15
XCode                     13            16
Ubuntu                    22.04         24.04
CentOS                    8             9
Clang                     14            18
g++                       11            14
Alpine Linux              3.16          3.20
:ref:`buildenvcmake`      3.23          3.31
========================= ======        ===========

liblsl works on very old (e.g. Windows 7) and tiny (e.g.
Raspberry Pi, some microcontrollers, Android) systems.
Some LSL Apps might have higher requirements (CMake 3.28+, C++20).

Common Requirements
-------------------

.. _Qt:


`Qt <http://qt.io>`__
`````````````````````

Qt6 is the required toolkit to create graphical user interfaces for LSL apps.
Qt 6.8 LTS is the recommended version.

To build apps using Qt, install it and if CMake doesn't find it automatically
tell it where to find it, either by adding the compiler specific base path to
the :envvar:`PATH`
(:samp:`set {PATH}=C:\\Qt\\<version>\\<compiler_arch>;%PATH%`
on the same command line you call cmake from) or add the path to the Qt CMake
configuration to the cmake parameters
(:samp:`-D{Qt6_DIR}=C:/Qt/<version>/<compiler_arch>/lib/cmake/Qt6/`).

.. _boost:

`Boost <https://boost.org>`__
`````````````````````````````

Nowadays, Boost is mostly used for apps connecting to a device over the local network
with Boost.Asio. As these apps don't need any parts of Boost to be built, you can
just `download Boost <https://www.boost.org/users/download/>`__, extract it somewhere
and tell CMake where to find it (:samp:`-D{BOOST_ROOT}=path/to/boost`).

Environment Configuration
-------------------------

Windows
```````

Visual Studio
'''''''''''''

To get a minimal Visual Studio installation, copy this block into a file and
use "Import configuration" in the
`Visual Studio 2022 <https://visualstudio.com/downloads>`_
installer:

::

   {
       "version": "1.0",
       "components": [
           "microsoft.visualstudio.component.vc.coreide",
           "microsoft.visualstudio.component.vc.cmake.project"
       ]
   }

Visual Studio (2017 and newer) includes CMake.
For a system wide CMake installation, download the
`.msi installer <https://cmake.org/download/>`__
and check the :guilabel:`Add to the path (for all users)` box.

Qt
''

Qt can be installed with the
`official Qt installer <http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe>`__

macOS
`````

Note: macOS users are expected to have `homebrew <https://brew.sh/>`__ installed.

- :command:`brew install cmake`

- :command:`brew install qt` (for building GUI apps)

liblsl Dependency
'''''''''''''''''

LSL apps automatically fetch and build liblsl using CMake's FetchContent when
``LSL_FETCH_IF_MISSING=ON`` (the default). You don't need to install liblsl
separately.

Those who installed liblsl to the system can point CMake to a pre-built installation:

.. code-block:: bash

   cmake -S . -B build -DLSL_INSTALL_ROOT=/path/to/liblsl/install

Apple Code-signing and Notarization
'''''''''''''''''''''''''''''''''''

If you want to distribute your app or custom lsl Framework on Apple hardware other than your own, and you don't want to
require the target users to self-compile, then you must build, codesign and notarize your binary. This requires an
Apple Developer account and Certificate (~$100 USD/year) and a Mac with Xcode installed.

**Setting up your local signing environment:**

1. Create an Apple Developer account and enroll in the `Apple Developer Program <https://developer.apple.com/programs/enroll/>`__.

2. Create certificates in the `Certificates, Identifiers & Profiles <https://developer.apple.com/account/resources/certificates/list>`__ section:

   - **Developer ID Application** - for signing frameworks and apps distributed outside the App Store
   - **Developer ID Installer** - for signing .pkg installer packages

3. Generate a Certificate Signing Request (CSR):

   - Open "Keychain Access" on macOS
   - Select ``Certificate Assistant`` > ``Request a Certificate From a Certificate Authority...``
   - Save the .certSigningRequest file

4. Upload the CSR to Apple Developer portal and download the certificates.

5. Double-click the downloaded certificates to install them in your Keychain.

6. Create an App-Specific Password for notarization in `Apple ID settings <https://appleid.apple.com/account/manage>`__.

7. Store notarization credentials:

   .. code-block:: bash

      xcrun notarytool store-credentials "notarytool-profile" \
        --apple-id "your-apple-id@example.com" \
        --team-id "YOUR_TEAM_ID" \
        --password "your-app-specific-password"

**Using the liblsl signing scripts:**

liblsl provides reusable scripts for code signing and notarization in the ``scripts/`` directory:

``apple_codesign.sh``
   Signs macOS or iOS frameworks with the appropriate identity and entitlements.

   .. code-block:: bash

      # Sign with Developer ID (production)
      ./scripts/apple_codesign.sh install/Frameworks/lsl.framework --platform macos

      # Ad-hoc signing for local development (no certificate required)
      APPLE_CODE_SIGN_IDENTITY_APP="-" ./scripts/apple_codesign.sh install/Frameworks/lsl.framework

``apple_package_notarize.sh``
   Creates a .pkg installer and optionally submits it for notarization.

   .. code-block:: bash

      # Create signed package only
      ./scripts/apple_package_notarize.sh install/Frameworks/lsl.framework --output package/

      # Create, notarize, and staple
      ./scripts/apple_package_notarize.sh install/Frameworks/lsl.framework --notarize --output package/

``apple_create_xcframework.sh``
   Creates a signed XCFramework from macOS, iOS, and iOS Simulator frameworks.

   .. code-block:: bash

      ./scripts/apple_create_xcframework.sh \
        --macos build-macOS/Frameworks/lsl.framework \
        --ios build-iOS/Frameworks/lsl.framework \
        --ios-simulator build-iOS-Simulator/Frameworks/lsl.framework \
        --output package/

``build_apple_frameworks.sh``
   Convenience wrapper that builds all platforms and calls the above scripts.

   .. code-block:: bash

      # Build macOS framework with ad-hoc signing
      APPLE_CODE_SIGN_IDENTITY_APP="-" ./scripts/build_apple_frameworks.sh macos

      # Build all platforms and create XCFramework
      ./scripts/build_apple_frameworks.sh all

      # Build and notarize
      ./scripts/build_apple_frameworks.sh macos --notarize

**Environment variables used by the scripts:**

================================== ================================================
Variable                           Description
================================== ================================================
APPLE_CODE_SIGN_IDENTITY_APP       App/framework signing identity (default: "Developer ID Application")
APPLE_CODE_SIGN_IDENTITY_INST      Installer signing identity (default: "Developer ID Installer")
APPLE_DEVELOPMENT_TEAM             Team ID for notarization
APPLE_NOTARIZE_USERNAME            Apple ID email for notarization
APPLE_NOTARIZE_PASSWORD            App-specific password for notarization
ENTITLEMENTS_FILE                  Path to entitlements file (default: lsl.entitlements)
================================== ================================================

Apple Code-signing in GitHub Actions
''''''''''''''''''''''''''''''''''''

To enable code signing and notarization in GitHub Actions CI:

1. Export your certificates from Keychain Access:

   - Find your "Developer ID Application" and "Developer ID Installer" certificates
   - Right-click each and select "Export" to save as .p12 files
   - Remember the export passwords

2. Convert certificates to base64:

   .. code-block:: bash

      base64 -i "Developer_ID_Application.p12" -o app_cert.base64
      base64 -i "Developer_ID_Installer.p12" -o inst_cert.base64

3. Create GitHub Actions secrets in your repository or organization:

   =============================== ================================================
   Secret Name                     Value
   =============================== ================================================
   PROD_MACOS_CERTIFICATE          Base64-encoded Developer ID Application .p12
   PROD_MACOS_CERTIFICATE_INST     Base64-encoded Developer ID Installer .p12
   PROD_MACOS_CERTIFICATE_PWD      Password used when exporting the .p12 files
   PROD_MACOS_CI_KEYCHAIN_PWD      Random password for the CI keychain (generate one)
   PROD_MACOS_NOTARIZATION_APPLE_ID  Your Apple Developer email
   PROD_MACOS_NOTARIZATION_PWD     App-specific password for notarization
   PROD_MACOS_NOTARIZATION_TEAM_ID Your Team ID from the Apple Developer portal
   =============================== ================================================

4. Use the ``install-apple-certs`` action and signing scripts in your workflow.

**Examples:**

- See `liblsl/.github/workflows/apple.yml <https://github.com/sccn/liblsl/blob/master/.github/workflows/apple.yml>`__ for the complete Apple CI workflow
- See `liblsl/.github/actions/install-apple-certs <https://github.com/sccn/liblsl/tree/master/.github/actions/install-apple-certs>`__ for the certificate installation action
- See `AppTemplate_cpp_qt <https://github.com/labstreaminglayer/AppTemplate_cpp_qt>`__ for a reference LSL application with signing

Debian / Ubuntu
```````````````

Build Tools
'''''''''''

- :command:`apt install build-essential g++ cmake`

For Ubuntu 22.04 which ships with CMake 3.22, you may need a newer version.
`PyPI <https://pypi.org/project/cmake/>`_ has newer precompiled CMake binaries:

- :command:`python -m pip install cmake`

Or use the `lukka/get-cmake <https://github.com/lukka/get-cmake>`__ GitHub Action in CI.

Qt
''

For Ubuntu 22.04 and newer, install Qt6 from the system packages:

- :command:`apt install qt6-base-dev libgl1-mesa-dev`

For apps requiring specific Qt versions, use `aqtinstall <https://aqtinstall.readthedocs.io/en/latest/>`__:

.. code-block:: bash

   pip install aqtinstall
   aqt install-qt --outputdir /opt/Qt linux desktop 6.8.0
   # Use with: -DQt6_DIR=/opt/Qt/6.8.0/gcc_64/lib/cmake/Qt6

For your application to run, it needs to find Qt libraries. Add the following to your .bashrc:

.. code-block:: bash

   export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/Qt/6.8.0/gcc_64/lib"
