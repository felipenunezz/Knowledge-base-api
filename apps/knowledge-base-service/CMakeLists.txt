#dont commit this file.
add_executable(knowledge-base-service
        src/main.cpp
)

target_link_libraries(knowledge-base-service PRIVATE
        migrations
        storage
        domain
        Drogon::Drogon
)