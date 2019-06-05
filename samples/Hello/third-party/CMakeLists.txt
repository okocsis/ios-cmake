include(ExternalProject)


### fuzzylite ###
if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/fuzzylite/fuzzylite/CMakeLists.txt)
	message(FATAL_ERROR "The fuzzylite submodule could not be found. Please run
git submodule update --init")
endif()

option(FL_BUILD_STATIC "" ON)
option(FL_BUILD_SHARED "" OFF)
option(FL_BUILD_BINARY "" OFF)
option(FL_BUILD_TESTS "" OFF)
option(FL_CPP11 "" ON)
option(FL_BACKTRACE "" OFF)
add_subdirectory(fuzzylite/fuzzylite)


### googletest ###
if(NECORE_COMPILE_TESTS)
	if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/googletest/CMakeLists.txt)
		message(FATAL_ERROR "The googletest submodule could not be found. Please run
	git submodule update --init")
	endif()

	cmake_policy(SET CMP0022 NEW)
	option(BUILD_GMOCK "" ON)
	option(BUILD_GTEST "" ON)
	option(INSTALL_GMOCK "" OFF)
	option(INSTALL_GTEST "" OFF)
	add_subdirectory(googletest)
endif()


### asio ###
if(NOT USE_BOOST_ASIO)
	set(ASIO_DIR ${CMAKE_CURRENT_SOURCE_DIR}/asio/asio)
	set(ASIO_TARGET ${ASIO_DIR}/CMakeFiles)

	if(NOT EXISTS ${ASIO_DIR}/configure.ac)
		message(FATAL_ERROR "The asio submodule could not be found. Please run
git submodule update --init")
	endif()

#	ExternalProject_Add(
#		asio
#		SOURCE_DIR ${ASIO_DIR}
#		CONFIGURE_COMMAND ${ASIO_DIR}/autogen.sh && ${ASIO_DIR}/configure --prefix=${ASIO_TARGET} --host=(NEED TO GET THE TRIPLE SOMEHOW) STANDALONE=yes
#		PREFIX ${ASIO_DIR}
#		BUILD_COMMAND make
#		BUILD_IN_SOURCE 1)
	set(asio_INCLUDE_DIRS ${ASIO_DIR}/include PARENT_SCOPE)

	# Add as header-only library
	add_library(asio INTERFACE)
	target_include_directories(asio SYSTEM INTERFACE ${asio_INCLUDE_DIRS})
endif()

### boost ###
if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/boost/CMakeLists.txt)
	message(FATAL_ERROR "The Boost submodule could not be found. Please run
git submodule update --init")
endif()

message(STATUS "Adding Boost dependencies - this may take some time to download")
set(BOOST_URL "https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2" CACHE STRING "Boost download URL")
set(BOOST_URL_SHA256 "8f32d4617390d1c2d16f26a27ab60d97807b35440d45891fa340fc2648b04406" CACHE STRING "Boost download URL SHA256 checksum")
option(BOOST_DOWNLOAD_TO_BINARY_DIR ON)
add_subdirectory(boost)