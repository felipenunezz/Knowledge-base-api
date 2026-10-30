#pragma once
#pragma once
#include "DomainModels.h"
#include <optional>
#include <vector>

namespace kb::domain {

    class IPageRepository {
    public:
        virtual ~IPageRepository() = default;
        virtual std::optional<Page> find(Uuid id) = 0;
        virtual void create(const Page& page) = 0;
        virtual bool updateWithVersionCheck(const Page& page, int expectedVersion) = 0;
        virtual std::vector<Page> getTreeBySpace(Uuid spaceId) = 0;
        virtual void softDelete(Uuid id) = 0;
    };

    class IUserRepository {
    public:
        virtual ~IUserRepository() = default;
        virtual std::optional<User> findByLogin(const std::string& login) = 0;
        virtual std::optional<User> findById(Uuid id) = 0;
        virtual void create(const User& user) = 0;
    };

    class IAuditRepository {
    public:
        virtual ~IAuditRepository() = default;
        virtual void append(const AuditEvent& event) = 0;
    };

}