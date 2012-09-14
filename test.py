#!/usr/bin/env python

from __future__ import print_function
import os
import platform
import shutil
import subprocess
import sys

if sys.version_info < (2,6):
    print("must be run with at least Python 2.6", file=sys.stderr)
    sys.exit(1)

try:
    import argparse
except ImportError:
    print("Could not find argparse module! This indicates you are running a version of Python "
        "older than 2.7. Run `sudo easy_install argparse` to install it and try again.")
    sys.exit(1)

parser = argparse.ArgumentParser(description='Test CMake TargetArch module using various generators.')

if platform.system() == "Windows":
    parser.add_argument("--msys", action="store_true", help="Test MSYS Makefiles generator")
    parser.add_argument("--mingw", action="store_true", help="Test MinGW Makefiles generator")
    parser.add_argument("--nmake", action="store_true", help="Test NMake Makefiles generator")
    parser.add_argument("--nmake-jom", action="store_true", help="Test NMake Makefiles JOM generator")
    parser.add_argument("--vs9", action="store_true", help="Test all Visual Studio 9 (2008) generators")
    parser.add_argument("--vs10", action="store_true", help="Test all Visual Studio 10 (2010) generators")
    parser.add_argument("--vs11", action="store_true", help="Test all Visual Studio 11 (2012) generators")

args = parser.parse_args()

rootSourceDirectory = os.path.dirname(os.path.realpath(__file__))
rootBuildDirectory = os.path.join(rootSourceDirectory, "targetarch-build")
if os.path.exists(rootBuildDirectory):
    shutil.rmtree(rootBuildDirectory)

def runTest(archs, generator):
    buildDirectory = os.path.join(rootBuildDirectory, generator + archs.replace(";", "+"))

    os.makedirs(buildDirectory)
    os.chdir(buildDirectory)

    cmakeCommand = 'cmake -DCMAKE_OSX_ARCHITECTURES="%(archs)s" -G "%(generator)s" "%(srcdir)s"' % \
        { 'archs': archs, 'generator': generator, 'srcdir': rootSourceDirectory }

    try:
        output = subprocess.check_output(cmakeCommand, shell=True)
        outputLines = output.splitlines()
        for line in outputLines:
            if line.startswith("-- Target arch"):
                if platform.system() == "Darwin" and archs:
                    print('%(line)s using generator "%(generator)s" / arch %(archs)s' % { 'line': line, 'generator': generator, 'archs': archs })
                else:
                    print('%(line)s using generator "%(generator)s"' % { 'line': line, 'generator': generator })

        return output
    except subprocess.CalledProcessError, e:
        if e.returncode < 0:
            print("cmake was terminated by signal", -e.returncode, file=sys.stderr)
        elif e.returncode > 0:
            print("cmake returned", e.returncode, file=sys.stderr)

        sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(1)
    except OSError, e:
        print("Execution failed:", e, file=sys.stderr)
        sys.exit(1)

aggregatedOutput = ""

# On OS X we can manually set CMAKE_OSX_ARCHITECTURES...
if platform.system() == "Darwin":
    for generator in ['Xcode', 'Unix Makefiles']:
        aggregatedOutput += runTest("i386", generator)
        aggregatedOutput += runTest("x86_64", generator)
        aggregatedOutput += runTest("i386;x86_64", generator)
        aggregatedOutput += runTest("", generator)
elif platform.system() == "Windows":
    generators = []

    if args.msys:
        generators.append("MSYS Makefiles")

    if args.mingw:
        generators.append("MinGW Makefiles")

    if args.nmake:
        generators.append("NMake Makefiles")

    if args.nmake_jom:
        generators.append("NMake Makefiles JOM")

    if args.vs9:
        generators.append('Visual Studio 9 2008', 'Visual Studio 9 2008 IA64', 'Visual Studio 9 2008 Win64')

    if args.vs10:
        # 'Visual Studio 10 IA64' is broken, at least on my system
        # ia64 appears to work fine in its own command prompt using nmake
        generators.append('Visual Studio 10', 'Visual Studio 10 Win64')

    if args.vs11:
        generators.append('Visual Studio 11', 'Visual Studio 11 ARM', 'Visual Studio 11 Win64')

    for generator in generators:
        aggregatedOutput += runTest("", generator)
else:
    aggregatedOutput += runTest("", "Unix Makefiles")

print(aggregatedOutput)
