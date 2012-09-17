Solar CMake Modules [![Build Status](https://secure.travis-ci.org/petroules/solar-cmake.png)](http://travis-ci.org/petroules/solar-cmake)
===================================

This repository contains various CMake utility modules associated with the Solar platform integration and utility library for Qt.

## Modules

Here is a list of the CMake modules available and the functionality they provide:

### Target Architecture Detection <small>(TargetArch.cmake)</small>

*WARNING: this script is not passive - code will be executed merely by including the module*

CMake currently lacks a built-in way to detect the architecture (i386, x86_64, armv7, etc.) of the target platform. This module sets three variables after inclusion:

* `CMAKE_TARGET_ARCHITECTURES` - contains either the name of the target architecture, or if building universal binaries on OS X, a list of target architectures
* `CMAKE_TARGET_ARCHITECTURE_UNIVERSAL` - TRUE if `CMAKE_TARGET_ARCHITECTURES` contains more than one architecture; FALSE in all other cases
* `CMAKE_TARGET_ARCHITECTURE_CODE` - the string "universal" if `CMAKE_TARGET_ARCHITECTURE_UNIVERSAL` is TRUE, otherwise equivalent to `CMAKE_TARGET_ARCHITECTURES`; this can be useful for filename generation

**OS X / PowerPC note:** including this module causes CMake to throw an error if any of the architectures passed to `CMAKE_OSX_ARCHITECTURES` are invalid. Currently the list of valid architectures includes only i386 and x86_64, since Apple has not officially supported PowerPC development since the OS X 10.5 SDK. However if you're feeling adventurous, you can set the CMake variable `ppc_support` to TRUE before including this module, and ppc and ppc64 will be accepted as valid architectures.

There is an Python script included (test.py) that can be used to test this module (and others) with various generators and ensure that the correct results are returned.

### Git Utilities <small>(GitUtils.cmake)</small>

Provides various Git-related functions.

**git_shorttag(\<rev_id\>)**: retrieves the short tag of the HEAD commit and stores the result in **rev_id**. This can be useful for generating package filenames or in a config.h header.

**git_append_shorttag(\<var_name\>)**: calls **git_shorttag** and appends "git-" and the result to the given variable. This is useful for generating version numbers. For example if **var_name** contains "1.0.2", it will contain something like "1.0.2-git0a1b2c" after calling this function.

### Qt Utilities <small>(QtUtils.cmake)</small>

Provides various Qt-related functions.

**qt_transform_sources(\<output_var\> \<sources\>)**: operates on a list of source files and executes all necessary commands to run the various Qt programs such as rcc, uic, moc and lrelease making the use of Qt within CMake very transparent. Files are also grouped into different folders in the IDE for easier code navigation and sorted alphabetically. Simply call `qt_transform_sources(my_sources "${my_sources}")` to process the source list for any target.

**use_qt_sdk_locations()**: adds some extra paths to CMAKE_PREFIX_PATHS allowing CMake to find Qt installations in the Qt SDK for Windows folders. This is a macro.

### Miscellaneous Utilities <small>(MiscUtils.cmake)</small>

Provides various utility functions…

**group_by_folder(\<relative_to_folder\> \<files\>)**: Groups a list of source files according to their directory hierarchy

relative_to_folder should be the prefix to strip of the beginning of each file path before doing categorization.

files should be a list of absolute paths to be grouped.

For example, given the file path: */Developer/Sources/solar-cmake/foo/bar/test.c*, if **relative_to_folder** is set to */Developer/Sources/solar-cmake*, the IDE folder name of the file *test.c* will be set to "foo\\\\bar".

**is_symbol_defined(\<output_variable\> \<symbol\>)**: Determines whether the current C compiler defines the given preprocessor symbol and stores the result in **output_variable**.

This function utilizes try_compile and some preprocessor trickery to determine whether the given symbol is defined. For example, after calling *is_symbol_defined(is_64_bit \_\_x86_64\_\_)*, the variable *is_64_bit* will be set to TRUE if compiling for a 64-bit environment.

**check_clang()**: Sets CMAKE_COMPILER_IS_CLANGXX to true if the current compiler is Clang.

This function merely calls **is_symbol_defined(\.\.\. \_\_clang\_\_)** and stores the result in *CMAKE_COMPILER_IS_CLANGXX*.

---

To include all modules, simply include Solar.cmake.

Bug tracker
-----------

If you've found a bug, please create an issue here on GitHub!

https://github.com/petroules/solar-cmake/issues

FAQ
---

**Q: System requirements?**

A: CMake 2.6 (as far as I know) and Python 2.7 for the testing script.

Authors
-------

**Jake Petroules**

+ http://twitter.com/jakepetroules
+ http://github.com/jakepetroules

Copyright and license
---------------------

Copyright (c) 2012 Petroules Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
