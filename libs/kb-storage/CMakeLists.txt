# 1. Drogon generated models
# TODO IMPORTANT: generate these using drogon_ctl and commit them. currently unable to
set(MODEL_SOURCES
        models/Pages.cc
        models/PageVersions.cc
        models/Users.cc
        models/Sessions.cc
        models/Spaces.cc
        models/SpaceMembers.cc
        models/Comments.cc
        models/Attachments.cc
        models/AuditLog.cc
        models/Permissions.cc
)

add_library(kb-storage STATIC
        src/PostgresPageRepository.cpp
        #TODO: src/PostgresUserRepository.cpp
        #TODO: src/PostgresAuditRepository.cpp
        #TODO: src/PostgresPageVersionRepository.cpp

        ${MODEL_SOURCES}
)

target_include_directories(kb-storage PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/models>
)

target_link_libraries(kb-storage
        PUBLIC
        kb-domain
        Drogon::Drogon
        PostgreSQL::PostgreSQL
)