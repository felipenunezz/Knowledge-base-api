#pragma once
#include "repository_interface.h"

namespace kb::storage {

    class PostgresPageRepository : public kb::domain::IPageRepository {
    public:
        std::optional<kb::domain::Page> find(kb::domain::Uuid id) override;
        void create(const kb::domain::Page& page) override;
        bool updateWithVersionCheck(const kb::domain::Page& page, int expectedVersion) override;
        std::vector<kb::domain::Page> getTreeBySpace(kb::domain::Uuid spaceId) override;
        void softDelete(kb::domain::Uuid id) override;
    };

    class PostgresUserRepository : public kb::domain::IUserRepository {
    public:
        std::optional<kb::domain::User> findById(kb::domain::Uuid id) override;
        std::optional<kb::domain::User> findByLogin(const std::string& login) override;
        void create(const kb::domain::User& user) override;
    };

    class PostgresAuditRepository : public kb::domain::IAuditRepository {
    public:
        void append(const kb::domain::AuditEvent& event) override;
    };

