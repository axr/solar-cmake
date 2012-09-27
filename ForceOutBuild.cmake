# Include this file at the top of your project to force out-of-source builds

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR "You should not build in-source. Use a directory outside the source tree or a subdirectory such as: ${CMAKE_SOURCE_DIR}/build")
endif()
