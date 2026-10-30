cmake_minimum_required(VERSION 4.0)

project(knowledge-base LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Drogon CONFIG REQUIRED)
find_package(PostgreSQL REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(GTest CONFIG REQUIRED)

enable_testing()

add_subdirectory(libs)
add_subdirectory(migrations)
add_subdirectory(apps/knowledge-base-service)
add_subdirectory(tests)

#TODO: fix compilation, my version of it doesnt work and i dont have the ones from my colleagues.
#TODO: Dockerfile is not right either. its giving me wierd errors, and im not really good Docker so its taking its sweet time