cmake_minimum_required(VERSION 2.8)

project(regex-test-project)
add_executable(regex-test main.cpp)
add_definitions("-O2 -pipe -msse2 -std=c++0x")

include(FindPkgConfig)

set(packages glibmm-2.4 giomm-2.4)
foreach(pkg ${packages})
    pkg_check_modules(${pkg} ${pkg})
    add_definitions(${${pkg}_CFLAGS}) 
    target_link_libraries(regex-test ${${pkg}_LDFLAGS})
endforeach(pkg)

