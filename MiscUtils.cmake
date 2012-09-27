function(group_by_folder relative_to_folder files)
    foreach(core_SOURCE ${files})
        # Get the path of the file relative to the current source directory
        file(RELATIVE_PATH core_SOURCE_relative "${relative_to_folder}" "${core_SOURCE}")

        # Get the relative folder path
        get_filename_component(core_SOURCE_dir "${core_SOURCE_relative}" PATH)

        # Convert forward slashes to backslashes to get source group identifiers
        string(REPLACE "/" "\\" core_SOURCE_group "${core_SOURCE_dir}")

        source_group("${core_SOURCE_group}" FILES "${core_SOURCE}")
    endforeach()
endfunction()

# Detects whether a preprocessor symbol is defined by the current C compiler
function(is_symbol_defined output_variable symbol)
    enable_language(C)

set(is_symbol_defined_code "
#if defined(${symbol})
int main() { return 0; }
#endif
")

    file(WRITE "${CMAKE_BINARY_DIR}/is_symbol_defined.c" "${is_symbol_defined_code}")

    try_compile(is_symbol_defined_result "${CMAKE_BINARY_DIR}" "${CMAKE_BINARY_DIR}/is_symbol_defined.c")

    if(is_symbol_defined_result)
        set(${output_variable} TRUE PARENT_SCOPE)
    else()
        set(${output_variable} FALSE PARENT_SCOPE)
    endif()
endfunction()
