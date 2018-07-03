# Continuous Integration

LSL, especially liblsl, aims to support a wide range of target devices and
operating systems. Seemingly harmless changes that compile fine on a - typically modern - system with manually installed development libraries could break older systems.

This is where
[Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration)
comes into play.
We use [Travis CI](https://travis-ci.com)(Ubuntu 14.04, OS X) and
[AppVeyor](https://appveyor.com)(Windows, Ubuntu 16.04 planned) to build
specific commits on multiple systems to see if everything builds in a clean,
defined environment and to provide binaries.

AppVeyor also allows you to download the build directory afterwards.

The principle is the same for all CI providers:

- the repository contains a configuration file that defines
  - which VM image the CI provider should use (e.g. OS X, Windows 10)
  - which software to install before each build (e.g. Boost)
  - build steps for the library / app
  - where to upload the files
- you link your CI account to your GitHub account
- when triggered (manually or on each commit / PR), the CI builds the repo by:
  - starting a clean VM / container
  - cloning the repository to the VM
  - running the steps detailed in the configuration file
  - on success, uploading the binaries
  - on failure, sending angry notifications
  - (PRs): adding the build status to the PR

Annotated examples for [AppVeyor](https://github.com/labstreaminglayer/App-BestPracticesGUI/blob/master/doc/appveyor.yml.md)
and [Travis CI](https://github.com/labstreaminglayer/App-BestPracticesGUI/blob/master/doc/.travis.yml.md)
can be found in the [BestPracticesGUI app](https://github.com/labstreaminglayer/App-BestPracticesGUI).

## Using CI systems

To start your own builds, you have to register with each CI provider (most 
offer free accounts with a limited number of concurrent builds for open source
projects that are linked to your GitHub-Account) and enable builds for your
fork of the repository (members of the labstreaminglayer organization: the
official repository).

You can then configure automatic builds or trigger builds of the latest commit
via the CI site.

## `ci_console.html`

The main repository contains the `ci_console.html`, an HTML form with some
JavaScript that sends requests to build
- a specific commit / branch
- in a specific build environment (e.g. Visual Studio 2008)
- with custom settings (e.g. CMake build type, compiler flags, ...)

to the CI provider's API.
