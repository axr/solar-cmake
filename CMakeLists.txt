cmake_minimum_required(VERSION 2.6)
include(Solar.cmake)

message(STATUS "Target architectures: ${CMAKE_TARGET_ARCHITECTURES}")

if(CMAKE_TARGET_ARCHITECTURE_UNIVERSAL)
    message(STATUS "Building universal binaries for OS X")
endif()

check_clang()
message(STATUS "Compiler is Clang? ${CMAKE_COMPILER_IS_CLANGXX}")

git_shorttag(rev_id)
message(STATUS "Git revision ${rev_id}")

is_symbol_defined(symdef __linux__)
if(symdef)
    message(STATUS "Compiling for Linux!")
endif()

is_symbol_defined(symdef _WIN32)
if(symdef)
    message(STATUS "Compiling for Windows!")
endif()

is_symbol_defined(symdef __APPLE__)
if(symdef)
    message(STATUS "Compiling for OS X or iOS!")
endif()
