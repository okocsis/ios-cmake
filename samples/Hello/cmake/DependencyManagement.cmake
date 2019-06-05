### Check compiler features ###
include(${CMAKE_CURRENT_LIST_DIR}/CheckCXX11Regex.cmake)
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++17" COMPILER_SUPPORTS_CXX17)
CHECK_CXX_COMPILER_FLAG("-std=c++14" COMPILER_SUPPORTS_CXX14)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)

# Allow system libraries to be used when cross-compiling.
# This is especially for Boost, which isn't in iOS or Android.
# Be careful to only use header-only libraries or cross-compiled libraries.
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)

macro(get_WIN32_WINNT version)
    if(WIN32 AND CMAKE_SYSTEM_VERSION)
        set(ver ${CMAKE_SYSTEM_VERSION})
        string(REPLACE "." "" ver ${ver})
        string(REGEX REPLACE "([0-9])" "0\\1" ver ${ver})

        set(${version} "0x${ver}")
    endif()
endmacro()

if(CYGWIN)
    add_compile_options("-D_BSD_SOURCE")
endif()

if (WIN32 OR CYGWIN)
    macro(get_WIN32_WINNT version)
        if (CMAKE_SYSTEM_VERSION)
            set(ver ${CMAKE_SYSTEM_VERSION})
            string(REGEX MATCH "^([0-9]+).([0-9])" ver ${ver})
            string(REGEX MATCH "^([0-9]+)" verMajor ${ver})
            # Check for Windows 10, b/c we'll need to convert to hex 'A'.
            if ("${verMajor}" MATCHES "10")
                set(verMajor "A")
                string(REGEX REPLACE "^([0-9]+)" ${verMajor} ver ${ver})
            endif ("${verMajor}" MATCHES "10")
            # Remove all remaining '.' characters.
            string(REPLACE "." "" ver ${ver})
            # Prepend each digit with a zero.
            string(REGEX REPLACE "([0-9A-Z])" "0\\1" ver ${ver})
            set(${version} "0x${ver}")
        endif(CMAKE_SYSTEM_VERSION)
    endmacro(get_WIN32_WINNT)

    get_WIN32_WINNT(ver)
    add_definitions(-D_WIN32_WINNT=${ver})
endif()

if(WIN32 OR CYGWIN)
    add_definitions("-D__USE_W32_SOCKETS")
endif()


### Alternatives options ###
include(CMakeDependentOption)

if("${CMAKE_BUILD_TYPE}" STREQUAL "Release" OR "${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    set(DEFAULT_LOG_LEVEL 4)
else()
    set(DEFAULT_LOG_LEVEL 0)
endif()

set(MIN_LOG_LEVEL ${DEFAULT_LOG_LEVEL} CACHE STRING "Minimum log level as an integer (2=Verbose, 7=Assert)")
option(ENABLE_STACKTRACE "Enable stacktraces in the logger (requires libdl)" ON)
option(ENABLE_SIGNAL_HANDLING "Enable signal handling in the logger (GNU only)" ON)
option(USE_BOOST_ASIO "Use boost::asio library (uses bundled copy otherwise)" OFF)
option(USE_BOOST_DATE_TIME "Link boost::date_time library (uses headers-only otherwise)" OFF)
option(USE_BOOST_FILESYSTEM "Use boost::filesystem library (uses bundled alternative otherwise)" OFF)
option(USE_BOOST_REGEX "Use boost::regex library (uses std::regex or boost::xpressive otherwise)" OFF)

cmake_dependent_option(USE_BOOST_XPRESSIVE "Use with Boost libraries" OFF
                       "NOT USE_BOOST_REGEX;HAVE_CXX11_REGEX" ON)

cmake_dependent_option(USE_BOOST_LIBS "Compile with Boost libraries" OFF
                       "NOT USE_BOOST_ASIO;NOT USE_BOOST_DATE_TIME;NOT USE_BOOST_REGEX" ON)

if(NOT HAVE_CXX11_REGEX)
    message(STATUS "Working std::regex not found, using boost::xpressive")
    set(USE_BOOST_XPRESSIVE ON)
endif()


### Boost ###
set(BOOST_COMPONENTS "")

if(USE_BOOST_ASIO)
    list(APPEND BOOST_COMPONENTS "system")
endif()
if(USE_BOOST_DATE_TIME)
    list(APPEND BOOST_COMPONENTS "date_time")
endif()
if(USE_BOOST_FILESYSTEM)
    list(APPEND BOOST_COMPONENTS "filesystem")
endif()
if(USE_BOOST_REGEX)
    list(APPEND BOOST_COMPONENTS "regex")
endif()

set(BOOST_LIBRARIES "Boost::boost")
foreach(c ${BOOST_COMPONENTS})
    list(APPEND BOOST_LIBRARIES "Boost::${c}")
endforeach()

message(STATUS "MIN_LOG_LEVEL=${MIN_LOG_LEVEL}")
message(STATUS "ENABLE_STACKTRACE=${ENABLE_STACKTRACE}")
message(STATUS "ENABLE_SIGNAL_HANDLING=${ENABLE_SIGNAL_HANDLING}")
message(STATUS "USE_BOOST_ASIO=${USE_BOOST_ASIO}")
message(STATUS "USE_BOOST_DATE_TIME=${USE_BOOST_DATE_TIME}")
message(STATUS "USE_BOOST_FILESYSTEM=${USE_BOOST_FILESYSTEM}")
message(STATUS "USE_BOOST_REGEX=${USE_BOOST_REGEX}")
message(STATUS "USE_BOOST_XPRESSIVE=${USE_BOOST_XPRESSIVE}")
message(STATUS "USE_BOOST_LIBS=${USE_BOOST_LIBS}")
