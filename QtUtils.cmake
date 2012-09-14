function(qt_transform_sources output_var sources)
    # include output directory for the *_ui.h files
    include_directories(${CMAKE_CURRENT_BINARY_DIR})

    # If using Qt, runs rcc, uic, moc and lrelease and populates final_sources
    # with the list of actual source files to compile - if not using
    # Qt we'll simply get all files not ending with .qrc, .ui, .h or .ts
    foreach(file ${sources})
            # CMake has no scope... clear this out
            set(outfile )

            get_filename_component(file_name "${file}" NAME)

            # For some very odd reason, CMake's Visual Studio 2010 generator added
            # a particular file twice (once as a None and once as CustomBuild)
            # when that file used an absolute path... so convert our sources
            # to relative paths if possible...
            string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" file "${file}")

            # IGNORE these...
            if(NOT "${file_name}" STREQUAL ".DS_Store" AND NOT "${file_name}" STREQUAL "Thumbs.db")
                list(APPEND final_sources "${file}")
            endif()

            if("${file}" MATCHES "(.*)\\.(rc|manifest|plist|desktop)$")
                source_group("Resources" FILES "${file}")
            elseif("${file}" MATCHES "(.*)\\.(icns|ico)$")
                source_group("Resources\\Icons" FILES "${file}")
            elseif("${file}" MATCHES "(.*)\\.(png|jpg|jpeg|gif|tif|tiff|svg)$")
                source_group("Resources\\Images" FILES "${file}")
            elseif("${file}" MATCHES "(.*)\\.(xml|txt|rtf|pdf|url)$" AND NOT "${file_name}" STREQUAL "CMakeLists.txt")
                source_group("Resources\\Other" FILES "${file}")
            elseif(QT4_FOUND AND "${file}" MATCHES "(.*)\\.qrc$")
                qt4_add_resources(outfile "${file}")
                source_group("Qt Resources" FILES "${file}")
            elseif(QT4_FOUND AND "${file}" MATCHES "(.*)\\.ui$")
                qt4_wrap_ui(outfile "${file}")
                source_group("Qt Forms" FILES "${file}")
            elseif(QT4_FOUND AND "${file}" MATCHES "(.*)\\.ts$")
                qt4_add_translation(outfile "${file}")
                source_group("Qt Translations" FILES "${file}")
            elseif(QT4_FOUND AND "${file}" MATCHES "(.*)\\.h$")
                file(READ "${file}" file_memory_cache)
                if("${file_memory_cache}" MATCHES "Q_OBJECT")
                    qt4_wrap_cpp(outfile "${file}")
                endif()
            endif()

            # If we generated anything this round...
            if(outfile)
                list(APPEND final_sources "${outfile}")

                # Don't quote outfile because it's a list containing
                # the same filename twice (odd, I know...)
                source_group("Generated Files" FILES ${outfile})

                if(QtUtils_VERBOSE)
                    get_filename_component(outfile_name "${outfile}" NAME)
                    message("Generated ${outfile_name}")
                endif()
            endif()
    endforeach()

    # Remove any duplicate items from our final source list
    list(REMOVE_DUPLICATES final_sources)

    # Here is a nice trick to get real alphabetical ordering... most IDEs will
    # display the filenames of source files without any path. However, because
    # our list may include both relative and absolute paths, sorting it will
    # not produce the desired result since the sort key is the entire path
    # and not just the name part. So what we'll do is create a clone of our
    # source list, but prepend the name of each file to its path, then sort that
    # list, giving us true alphabetical ordering. Then we'll simply remove the
    # prefixes after sorting to get our original list back, but sorted appropriately.
    # We use four backslashes surrounded by colons to separate items since that sequence
    # is extremely unlikely to ever appear in any filename.
    foreach(final_source ${final_sources})
        get_filename_component(final_source_name "${final_source}" NAME)
        list(APPEND final_sources_sorter "${final_source_name}:\\\\\\\\:${final_source}")
    endforeach()

    list(SORT final_sources_sorter)
    set(final_sources ) # clear out the real variable

    foreach(final_source_sorted ${final_sources_sorter})
        string(REGEX REPLACE "(.*):\\\\\\\\\\\\\\\\:" "" final_source_sorted "${final_source_sorted}")
        list(APPEND final_sources "${final_source_sorted}")
    endforeach()

    # Sets the final_sources var to the parent scope so we can
    # pass it to add_executable or add_library
    set(${output_var} "${final_sources}" PARENT_SCOPE)
endfunction()

# Appends all possible Qt SDK location paths to CMAKE_PREFIX_PATH
# Currently only does anything on Windows
macro(use_qt_sdk_locations)
    set(QT_ALL_VERSIONS
        4.8.2
        4.8.1
        4.8.0
        4.7.4
        4.7.3
        4.7.2
        4.7.1
        4.7.0
        4.6.3
        4.6.2
        4.6.1
        4.6.0
        4.5.3
        4.5.2
        4.5.1
        4.5.0
    )

    if(MSVC10)
        foreach(qt_v ${QT_ALL_VERSIONS})
            list(APPEND CMAKE_PREFIX_PATH "C:\\QtSDK\\Desktop\\Qt\\${qt_v}\\msvc2010")
        endforeach()
    elseif(MSVC90)
        foreach(qt_v ${QT_ALL_VERSIONS})
            list(APPEND CMAKE_PREFIX_PATH "C:\\QtSDK\\Desktop\\Qt\\${qt_v}\\msvc2008")
        endforeach()
    elseif(MINGW)
        foreach(qt_v ${QT_ALL_VERSIONS})
            list(APPEND CMAKE_PREFIX_PATH "C:\\QtSDK\\Desktop\\Qt\\${qt_v}\\mingw")
        endforeach()
    endif()
endmacro()
