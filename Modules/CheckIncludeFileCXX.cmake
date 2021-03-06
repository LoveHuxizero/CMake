#.rst:
# CheckIncludeFileCXX
# -------------------
#
# Check if the include file exists.
#
# ::
#
#   CHECK_INCLUDE_FILE_CXX(INCLUDE VARIABLE)
#
#
#
# ::
#
#   INCLUDE  - name of include file
#   VARIABLE - variable to return result
#
#
#
# An optional third argument is the CFlags to add to the compile line or
# you can use CMAKE_REQUIRED_FLAGS.
#
# The following variables may be set before calling this macro to modify
# the way the check is run:
#
# ::
#
#   CMAKE_REQUIRED_FLAGS = string of compile command line flags
#   CMAKE_REQUIRED_DEFINITIONS = list of macros to define (-DFOO=bar)
#   CMAKE_REQUIRED_INCLUDES = list of include directories
#   CMAKE_REQUIRED_QUIET = execute quietly without messages

#=============================================================================
# Copyright 2002-2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

macro(CHECK_INCLUDE_FILE_CXX INCLUDE VARIABLE)
  if("${VARIABLE}" MATCHES "^${VARIABLE}$")
    if(CMAKE_REQUIRED_INCLUDES)
      set(CHECK_INCLUDE_FILE_CXX_INCLUDE_DIRS "-DINCLUDE_DIRECTORIES=${CMAKE_REQUIRED_INCLUDES}")
    else()
      set(CHECK_INCLUDE_FILE_CXX_INCLUDE_DIRS)
    endif()
    set(MACRO_CHECK_INCLUDE_FILE_FLAGS ${CMAKE_REQUIRED_FLAGS})
    set(CHECK_INCLUDE_FILE_VAR ${INCLUDE})
    configure_file(${CMAKE_ROOT}/Modules/CheckIncludeFile.cxx.in
      ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/CheckIncludeFile.cxx)
    if(NOT CMAKE_REQUIRED_QUIET)
      message(STATUS "Looking for C++ include ${INCLUDE}")
    endif()
    if(${ARGC} EQUAL 3)
      set(CMAKE_CXX_FLAGS_SAVE ${CMAKE_CXX_FLAGS})
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ARGV2}")
    endif()

    try_compile(${VARIABLE}
      ${CMAKE_BINARY_DIR}
      ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/CheckIncludeFile.cxx
      COMPILE_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS}
      CMAKE_FLAGS
      -DCOMPILE_DEFINITIONS:STRING=${MACRO_CHECK_INCLUDE_FILE_FLAGS}
      "${CHECK_INCLUDE_FILE_CXX_INCLUDE_DIRS}"
      OUTPUT_VARIABLE OUTPUT)

    if(${ARGC} EQUAL 3)
      set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS_SAVE})
    endif()

    if(${VARIABLE})
      if(NOT CMAKE_REQUIRED_QUIET)
        message(STATUS "Looking for C++ include ${INCLUDE} - found")
      endif()
      set(${VARIABLE} 1 CACHE INTERNAL "Have include ${INCLUDE}")
      file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
        "Determining if the include file ${INCLUDE} "
        "exists passed with the following output:\n"
        "${OUTPUT}\n\n")
    else()
      if(NOT CMAKE_REQUIRED_QUIET)
        message(STATUS "Looking for C++ include ${INCLUDE} - not found")
      endif()
      set(${VARIABLE} "" CACHE INTERNAL "Have include ${INCLUDE}")
      file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
        "Determining if the include file ${INCLUDE} "
        "exists failed with the following output:\n"
        "${OUTPUT}\n\n")
    endif()
  endif()
endmacro()
