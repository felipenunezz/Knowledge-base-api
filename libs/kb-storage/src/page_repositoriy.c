#include "postgres_repositories.h"
#include <drogon/orm/CoroMapper.h>
#include <drogon/orm/DbClient.h>
#include "models/Users.h"

#include "PostgresRepositories.h"
#include <drogon/orm/CoroMapper.h>
#include <drogon/orm/DbClient.h>
#include "models/Pages.h"
#include <stdexcept>

namespace kb::storage {
    using namespace drogon::orm;

    static DbClientPtr getDb() {
        return drogon::app().getDbClient();
    }

    static kb::domain::Page mapToDomain(const drogon_model::kb::Pages& row) {
        return kb::domain::Page{
            .id = row.getValueOfId(),
            .spaceId = row.getValueOfSpaceId(),
            .parentId = row.getParentId(),
            .path = row.getValueOfPath(),
            .title = row.getValueOfTitle(),
            .currentVersion = row.getValueOfCurrentVersion(),
            .isDeleted = row.getValueOfIsDeleted()
        };
    }

    std::optional<kb::domain::Page> PostgresPageRepository::find(kb::domain::Uuid id) {
        CoroMapper<drogon_model::kb::Pages> mapper(getDb());
        try {
            auto row = co_await mapper.findByPrimaryKey(id);
            return mapToDomain(row);
        } catch (const UnexpectedRows&) {
            return std::nullopt;
        }
    }

    void PostgresPageRepository::create(const kb::domain::Page& page) {
        CoroMapper<drogon_model::kb::Pages> mapper(getDb());
        drogon_model::kb::Pages dbRow;

        dbRow.setId(page.id);
        dbRow.setSpaceId(page.spaceId);
        if (page.parentId) {
            dbRow.setParentId(*page.parentId);
        }
        dbRow.setPath(page.path);
        dbRow.setTitle(page.title);
        dbRow.setCurrentVersion(1);
        dbRow.setIsDeleted(false);

        co_await mapper.insert(dbRow);
    }

    bool PostgresPageRepository::updateWithVersionCheck(const kb::domain::Page& page, int expectedVersion) {
        auto db = getDb();

        auto result = co_await db->execSqlCoro(
            "UPDATE pages "
            "SET title=$1, current_version = current_version + 1, updated_at = NOW() "
            "WHERE id=$2 AND current_version=$3",
            page.title, page.id, expectedVersion
        );

        if (result.affectedRows() == 0) {
            throw std::runtime_error("PAGE_VERSION_CONFLICT");
        }
        return true;
    }

    std::vector<kb::domain::Page> PostgresPageRepository::getTreeBySpace(kb::domain::Uuid spaceId) {
        CoroMapper<drogon_model::kb::Pages> mapper(getDb());

        auto rows = co_await mapper.findBy(
            Criteria(drogon_model::kb::Pages::Cols::_space_id, CompareOperator::EQ, spaceId)
        );

        std::vector<kb::domain::Page> pages;
        for (const auto& r : rows) {
            pages.push_back(mapToDomain(r));
        }
        return pages;
    }

    void PostgresPageRepository::softDelete(kb::domain::Uuid id) {
        auto db = getDb();
        co_await db->execSqlCoro(
            "UPDATE pages SET is_deleted = TRUE, updated_at = NOW() WHERE id=$1", id);
    }

}