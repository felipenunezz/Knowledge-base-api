cmake_minimum_required(VERSION 3.25...4.3)

project(knowledge-base LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)


set(CMAKE_POLICY_VERSION_MINIMUM 3.25)

include(FetchContent)

FetchContent_Declare(drogon
        GIT_REPOSITORY https://github.com/drogonframework/drogon.git
        GIT_TAG        v1.9.13
        GIT_SHALLOW    TRUE
)

set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_CTL      OFF CACHE BOOL "" FORCE)
set(BUILD_ORM      ON  CACHE BOOL "" FORCE)
set(BUILD_DOC      OFF CACHE BOOL "" FORCE)
set(BUILD_BROTLI   OFF CACHE BOOL "" FORCE)
set(BUILD_REDIS OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(drogon)

add_subdirectory(libs)
add_subdirectory(apps/knowledge-base-service)