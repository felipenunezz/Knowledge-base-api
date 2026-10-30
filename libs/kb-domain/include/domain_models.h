#pragma once
#include <string>
#include <optional>
#include <vector>
#include <chrono>

namespace kb::domain {

using Uuid = std::string;

struct User {
    Uuid id;
    std::string login;
    std::string passwordHash;
    std::string displayName;
    std::string email;
    bool isAdministrator{false};
    std::string status; // ACTIVE, BLOCKED
};

struct Session {
    Uuid id;
    Uuid userId;
    std::string tokenHash;
    std::string status;
};

struct Space {
    Uuid id;
    std::string name;
    std::optional<std::string> description;
    Uuid ownerId;
    std::string status;
};

struct SpaceMember {
    Uuid spaceId;
    Uuid userId;
    std::string role; // Administrator, Editor, Viewer
};

struct Page {
    Uuid id;
    Uuid spaceId;
    std::optional<Uuid> parentId;
    std::string path;
    std::string title;
    int currentVersion{1};
    bool isDeleted{false};
};

struct PageVersion {
    Uuid id;
    Uuid pageId;
    int version;
    std::string title;
    std::string content;
    Uuid authorId;
};


struct Comment {
    Uuid id;
    Uuid pageId;
    Uuid authorId;
    std::string content;
    bool isDeleted{false};
};

struct Attachment {
    Uuid id;
    Uuid pageId;
    std::string originalName;
    std::string storagePath;
    std::string mimeType;
    long long size;
    std::string checksumSha256;
    Uuid authorId;
};


struct AuditEvent {
    Uuid id;
    std::optional<Uuid> userId;
    std::string action;
    std::string objectType;
    std::optional<Uuid> objectId;
    std::string details;
};

}