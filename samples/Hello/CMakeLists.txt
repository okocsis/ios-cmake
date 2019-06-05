# Standard setup
cmake_minimum_required (VERSION 3.14.5)
project(Hello CXX C)

# ### Preamble ###
# # Must use GNUInstallDirs to install libraries into correct
# # locations on all platforms.
# include(GNUInstallDirs)

# # Segregate AppleClang from Clang
# cmake_policy(SET CMP0025 NEW)

# Includes
# include_directories(${Hello_SOURCE_DIR})

# Library
add_library(Hello)
# add_library(Hello::Hello ALIAS Hello)

add_subdirectory(./src)

target_include_directories(Hello
    PUBLIC 
        $<INSTALL_INTERFACE:include>    
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_compile_options(Hello PRIVATE -Werror)
target_compile_features(Hello PRIVATE cxx_std_11)

# Installation
# set(CMAKE_INSTALL_PREFIX "${Hello_SOURCE_DIR}/install")
install(TARGETS Hello 
    EXPORT
        HelloExport
    LIBRARY DESTINATION ${Hello_SOURCE_DIR}/fuck
)


# install(FILES HelloIOS.h DESTINATION .)
