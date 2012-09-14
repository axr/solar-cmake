function(git_shorttag rev_id)
    find_package(Git)
    if(GIT_FOUND AND EXISTS "${CMAKE_SOURCE_DIR}/.git" AND IS_DIRECTORY "${CMAKE_SOURCE_DIR}/.git")
        execute_process(
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
            OUTPUT_VARIABLE GIT_OUT OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(${rev_id} "${GIT_OUT}" PARENT_SCOPE)
    endif()
endfunction()

function(git_append_shorttag var_name)
    if(NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Release")
        git_shorttag(rev_id)
        if(NOT "${rev_id}" STREQUAL "")
            set(${var_name} "${${var_name}}-git${rev_id}" PARENT_SCOPE)
        endif()
    endif()
endfunction()
