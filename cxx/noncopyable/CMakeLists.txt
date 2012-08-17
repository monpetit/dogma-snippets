project(noncopyable_test)
cmake_minimum_required(VERSION 2.8)
aux_source_directory(. SRC_LIST)
add_executable(${PROJECT_NAME} ${SRC_LIST})



# 기본 CFLAGS : CMAKE_C_FLAGS
set(EXTRA_CFLAGS "-O2 -std=c++0x")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${EXTRA_CFLAGS}")
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} ${CMAKE_C_FLAGS})

#target_link_libraries(${PROJECT_NAME} alut openal)
#PKGCONFIG(package includedir libdir linkflags cflags)

