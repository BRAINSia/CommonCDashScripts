####################################################################################
# OS      : MacOSX 10.8
# Hardware: x86_64  (MacBook Air i7 processor)
# GPU     : Intel HD Graphics 3000 OpenGL Engine
# COMPILER: i686-apple-darwin11-llvm-gcc-4.2 (GCC) 4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2336.11.00)
####################################################################################
# WARNING - The specific version and processor type of this machine should be reported
# in the header above. Indeed, this file will be send to the dashboard as a NOTE file.
#
# On linux, you could run:
#     'uname -o' and 'cat /etc/*-release' to obtain the OS name.
#     'uname -mpi' to obtain hardware details.
#     'glxinfo | grep OpenGL' to obtain GPU details.
####################################################################################

cmake_minimum_required(VERSION 2.8.8)
#
# For additional information, see http://www.slicer.org/slicerWiki/index.php/Documentation/4.0/Developers/Tutorials/DashboardSetup
#

#  Get the short hostname for reporting
macro( GET_SHORT_HOSTNAME SHORT_HOSTNAME)
  site_name(MY_FULLY_QUALIFIED_HOSTNAME)
  string(REPLACE "." ";" HOSTNAME_LIST ${MY_FULLY_QUALIFIED_HOSTNAME})
  list(GET HOSTNAME_LIST 0 ${SHORT_HOSTNAME})
endmacro()
GET_SHORT_HOSTNAME(MY_HOSTNAME)
message(STATUS "SITE_NAME: ${MY_HOSTNAME}")
SET(USER_NAME $ENV{LOGNAME} CACHE STRING UserName)

# experimental:
#     - run_ctest() macro will be called *ONE* time
#     - binary directory will *NOT* be cleaned
# continuous:
#     - run_ctest() macro will be called EVERY 5 minutes ...
#     - binary directory will *NOT* be cleaned
#     - configure/build will be executed *ONLY* if the repository has been updated
# nightly:
#     - run_ctest() macro will be called *ONE* time
#     - binary directory *WILL BE* cleaned
set(SCRIPT_MODE "nightly") # "experimental", "continuous", "nightly"
#if ( NOT SCRIPT_MODE )
#  message(FATAL_ERROR "Must specify the script mode from the ctest command line:\n ctest -S ${CMAKE_CURRENT_LIST_FILE} -DSCRIPT_MODE:STRING=\"nightly\"")
#endif()


#-----------------------------------------------------------------------------
# Dashboard properties
#-----------------------------------------------------------------------------
set(PROJECT_INTERNAL_NAME "Slicer43")
set(MY_OPERATING_SYSTEM   "Darwin") # Windows, Linux, Darwin...
set(MY_COMPILER           "gcc")
set(MY_QT_VERSION         "4.8.2")
set(QT_QMAKE_EXECUTABLE   "/usr/local/bin/qmake"  ) # From homebrew distribution
set(CTEST_SITE            "${MY_HOSTNAME}.uiowa.edu")        # for example: mymachine.kitware, mymachine.bwh.harvard.edu, ...
set(CTEST_DASHBOARD_ROOT  "/scratch/${USER_NAME}/CDashAutoTest")
set(CTEST_BUILD_CONFIGURATION "Release")

# Each dashboard script should specify a unique ID per CTEST_DASHBOARD_ROOT.
# It means the following directories will be created:
#   <CTEST_DASHBOARD_ROOT>/<DIRECTORY_NAME>-<DIRECTORY_IDENTIFIER>        # Source directory
#   <CTEST_DASHBOARD_ROOT>/<DIRECTORY_NAME>-<DIRECTORY_IDENTIFIER>-build  # Build directory
get_filename_component(UNIQUE_BUILD_NAME ${CMAKE_CURRENT_LIST_FILE} NAME )
set(DIRECTORY_IDENTIFIER  "${MY_HOSTNAME}-${UNIQUE_BUILD_NAME}")

# Open a shell and type in "cmake --help" to obtain the proper spelling of the generator
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(MY_BITNESS            "64")

#-----------------------------------------------------------------------------
# Dashboard options
#-----------------------------------------------------------------------------
set(WITH_KWSTYLE FALSE)
set(WITH_MEMCHECK FALSE)
set(WITH_COVERAGE FALSE)
set(WITH_DOCUMENTATION FALSE)
#set(DOCUMENTATION_ARCHIVES_OUTPUT_DIRECTORY ) # for example: $ENV{HOME}/Projects/Doxygen

set(GIT_REPOSITORY "git://github.com/BRAINSia/Slicer43.git")
set(GIT_TAG "master")

set(CTEST_TEST_TIMEOUT 500)
set(CTEST_BUILD_FLAGS "-j23") # Use multiple CPU cores to build. For example "-j4" on unix
set(CTEST_PARALLEL_LEVEL 4) # Number of tests running in parallel
set(ENV{NSLOTS}          6) # If running more than one test at a time,
                             # then ensure that over allocation does not occur by
                             # ensuring that CTEST_PARALLEL_LEVEL * ENV{NSLOTS} < Total number of processor in computer

# You could invoke the script with the following syntax:
#  ctest -S karakoram_Slicer4_nightly.cmake -C <CTEST_BUILD_CONFIGURATION> -V
#
# Note that '-C <CTEST_BUILD_CONFIGURATION>' is mandatory on windows

#-----------------------------------------------------------------------------
# Additional CMakeCache options
#-----------------------------------------------------------------------------
set(ADDITIONAL_CMAKECACHE_OPTION "
  ADDITIONAL_C_FLAGS:STRING=
  ADDITIONAL_CXX_FLAGS:STRING=
")

#-----------------------------------------------------------------------------
# List of test that should be explicitly disabled on this machine
#-----------------------------------------------------------------------------
set(TEST_TO_EXCLUDE_REGEX "")

#-----------------------------------------------------------------------------
# Set any extra environment variables here
#-----------------------------------------------------------------------------
set(ENV{CC}      "/usr/bin/gcc")
set(ENV{CXX}     "/usr/bin/g++")
if(UNIX)
  set(ENV{DISPLAY} ":0")
endif()

#-----------------------------------------------------------------------------
# Required executables
#-----------------------------------------------------------------------------
find_program(CTEST_SVN_COMMAND NAMES svn)
find_program(CTEST_GIT_COMMAND NAMES git)
find_program(CTEST_COVERAGE_COMMAND NAMES gcov)
find_program(CTEST_MEMORYCHECK_COMMAND NAMES valgrind)

#-----------------------------------------------------------------------------
# Build Name
#-----------------------------------------------------------------------------
# Update the following variable to match the chosen build options. This variable is used to
# generate both the build directory and the build name.
# See http://www.cdash.org/CDash/index.php?project=Slicer4 for examples
set(BUILD_OPTIONS_STRING "${MY_BITNESS}bits-QT${MY_QT_VERSION}-ITK4")

#-----------------------------------------------------------------------------
# Directory name
#-----------------------------------------------------------------------------
set(DIRECTORY_NAME "${PROJECT_INTERNAL_NAME}")

#-----------------------------------------------------------------------------
# Build directory
#-----------------------------------------------------------------------------
set(CTEST_BINARY_DIRECTORY "${CTEST_DASHBOARD_ROOT}/${DIRECTORY_NAME}-${DIRECTORY_IDENTIFIER}-build")
file(WRITE "${CTEST_DASHBOARD_ROOT}/${DIRECTORY_NAME}-${DIRECTORY_IDENTIFIER}-build-${BUILD_OPTIONS_STRING}-${CTEST_BUILD_CONFIGURATION}-${SCRIPT_MODE}.txt" "Generated by ${CTEST_SCRIPT_NAME}")

#-----------------------------------------------------------------------------
# Source directory
#-----------------------------------------------------------------------------
set(CTEST_SOURCE_DIRECTORY "${CTEST_DASHBOARD_ROOT}/${DIRECTORY_NAME}-${DIRECTORY_IDENTIFIER}")


##########################################
# WARNING: DO NOT EDIT BEYOND THIS POINT #
##########################################

set(CTEST_NOTES_FILES "${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}")

#
# Project specific properties
#
set(CTEST_PROJECT_NAME "${PROJECT_INTERNAL_NAME}")
set(CTEST_BUILD_NAME "${MY_OPERATING_SYSTEM}-${MY_COMPILER}-${BUILD_OPTIONS_STRING}-${CTEST_BUILD_CONFIGURATION}")

#
# Display build info
#
message("CTEST_SITE ................: ${CTEST_SITE}")
message("CTEST_BUILD_NAME ..........: ${CTEST_BUILD_NAME}")
message("SCRIPT_MODE ...............: ${SCRIPT_MODE}")
message("CTEST_BUILD_CONFIGURATION .: ${CTEST_BUILD_CONFIGURATION}")
message("WITH_KWSTYLE ..............: ${WITH_KWSTYLE}")
message("WITH_COVERAGE: ............: ${WITH_COVERAGE}")
message("WITH_MEMCHECK .............: ${WITH_MEMCHECK}")
message("WITH_PACKAGES .............: ${WITH_PACKAGES}")
message("WITH_DOCUMENTATION ........: ${WITH_DOCUMENTATION}")
message("DOCUMENTATION_ARCHIVES_OUTPUT_DIRECTORY: ${DOCUMENTATION_ARCHIVES_OUTPUT_DIRECTORY}")

#
# Convenient function allowing to download a file
#
function(download_file url dest)
  file(DOWNLOAD ${url} ${dest} STATUS status)
  list(GET status 0 error_code)
  list(GET status 1 error_msg)
  if(error_code)
    message(FATAL_ERROR "error: Failed to download ${url} - ${error_msg}")
  endif()
endfunction()

#
# Download and include dashboard driver script
#
set(url file://${CTEST_SCRIPT_DIRECTORY}/../../CommonDashboardDriverScript.cmake)
set(dest ${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}.driver)
download_file(${url} ${dest})
include(${dest})

