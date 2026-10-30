project(kb-domain LANGUAGES CXX)
add_library(kb-domain INTERFACE)

target_include_directories(kb-domain INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)

target_link_libraries(kb-domain INTERFACE
        nlohmann_json::nlohmann_json
)