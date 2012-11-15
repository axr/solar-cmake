# Include this file in your project to force the CMake source and build directory
# to contain only Latin characters alphanumeric, dash, underscore, slash, dot
# (and colon on Windows)

if(WIN32)
    set(force_latin_paths_separator ":")
endif()

set(force_latin_paths_path_regex "^([A-Za-z0-9${force_latin_paths_separator}._/-]+)$")

if(NOT "${CMAKE_SOURCE_DIR}" MATCHES "${force_latin_paths_path_regex}" OR NOT "${CMAKE_BINARY_DIR}" MATCHES "${force_latin_paths_path_regex}")
    message(FATAL_ERROR "Ensure that the source and build paths contain only the following characters: alphanumeric, dash, underscore, slash, dot (and colon on Windows)")
endif()
