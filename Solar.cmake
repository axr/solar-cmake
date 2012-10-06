include(TargetArch)
include(GitUtils)
include(QtUtils)
include(MiscUtils)

# Set target architectures
target_architecture(CMAKE_TARGET_ARCHITECTURES)
list(LENGTH CMAKE_TARGET_ARCHITECTURES cmake_target_arch_len)
if(NOT "${cmake_target_arch_len}" STREQUAL "1")
    set(CMAKE_TARGET_ARCHITECTURE_UNIVERSAL TRUE)
    set(CMAKE_TARGET_ARCHITECTURE_CODE "universal")
else()
    set(CMAKE_TARGET_ARCHITECTURE_UNIVERSAL FALSE)
    set(CMAKE_TARGET_ARCHITECTURE_CODE "${CMAKE_TARGET_ARCHITECTURES}")
endif()

# Check if the C/C++ compiler is Clang/LLVM
is_symbol_defined(CMAKE_COMPILER_IS_CLANGXX __clang__)

use_qt_sdk_locations()

# The suffix of the thing that the user clicks as opposed to the actual executable
if(APPLE)
    set(CMAKE_USER_EXECUTABLE_SUFFIX ".app")
else()
    set(CMAKE_USER_EXECUTABLE_SUFFIX "${CMAKE_EXECUTABLE_SUFFIX}")
endif()
