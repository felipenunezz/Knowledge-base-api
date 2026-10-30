-- ==========================================
-- 1. USERS
-- ==========================================
CREATE TABLE users (
                       id UUID PRIMARY KEY,
                       login VARCHAR(255) UNIQUE NOT NULL,
                       password_hash VARCHAR(255) NOT NULL,
                       display_name VARCHAR(255) NOT NULL,
                       email VARCHAR(255) NOT NULL,
                       is_administrator BOOLEAN DEFAULT FALSE,
                       status VARCHAR(50) DEFAULT 'ACTIVE',
                       created_at TIMESTAMPTZ DEFAULT NOW(),
                       updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- 2. SESSIONS
-- ==========================================
CREATE TABLE sessions (
                          id UUID PRIMARY KEY,
                          user_id UUID NOT NULL REFERENCES users(id),
                          token_hash VARCHAR(255) UNIQUE NOT NULL,
                          created_at TIMESTAMPTZ DEFAULT NOW(),
                          expires_at TIMESTAMPTZ NOT NULL,
                          status VARCHAR(50) DEFAULT 'active'
);
CREATE INDEX idx_sessions_token ON sessions(token_hash);

-- ==========================================
-- 3. SPACES
-- ==========================================
CREATE TABLE spaces (
                        id UUID PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        description TEXT,
                        owner_id UUID NOT NULL REFERENCES users(id),
                        status VARCHAR(50) DEFAULT 'ACTIVE',
                        created_at TIMESTAMPTZ DEFAULT NOW(),
                        updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- 4. PERMISSIONS & SPACE MEMBERS
-- ==========================================
CREATE TABLE permissions (
                             role VARCHAR(50) NOT NULL,
                             permission VARCHAR(50) NOT NULL,
                             PRIMARY KEY (role, permission)
);

INSERT INTO permissions (role, permission) VALUES
                                               ('Administrator', 'SPACE_VIEW'), ('Administrator', 'SPACE_MANAGE'),
                                               ('Administrator', 'PAGE_VIEW'), ('Administrator', 'PAGE_CREATE'), ('Administrator', 'PAGE_EDIT'), ('Administrator', 'PAGE_DELETE'),
                                               ('Administrator', 'COMMENT_CREATE'), ('Administrator', 'ATTACHMENT_UPLOAD'), ('Administrator', 'ATTACHMENT_DELETE'),
                                               ('Space Administrator', 'SPACE_VIEW'), ('Space Administrator', 'SPACE_MANAGE'),
                                               ('Space Administrator', 'PAGE_VIEW'), ('Space Administrator', 'PAGE_CREATE'), ('Space Administrator', 'PAGE_EDIT'), ('Space Administrator', 'PAGE_DELETE'),
                                               ('Space Administrator', 'COMMENT_CREATE'), ('Space Administrator', 'ATTACHMENT_UPLOAD'), ('Space Administrator', 'ATTACHMENT_DELETE'),
                                               ('Editor', 'SPACE_VIEW'),
                                               ('Editor', 'PAGE_VIEW'), ('Editor', 'PAGE_CREATE'), ('Editor', 'PAGE_EDIT'), ('Editor', 'PAGE_DELETE'),
                                               ('Editor', 'COMMENT_CREATE'), ('Editor', 'ATTACHMENT_UPLOAD'), ('Editor', 'ATTACHMENT_DELETE'),
                                               ('Viewer', 'SPACE_VIEW'), ('Viewer', 'PAGE_VIEW'), ('Viewer', 'COMMENT_CREATE');

CREATE TABLE space_members (
                               space_id UUID NOT NULL REFERENCES spaces(id),
                               user_id UUID NOT NULL REFERENCES users(id),
                               role VARCHAR(50) NOT NULL,
                               PRIMARY KEY (space_id, user_id)
);

-- ==========================================
-- 5. PAGES
-- ==========================================
CREATE TABLE pages (
                       id UUID PRIMARY KEY,
                       space_id UUID NOT NULL REFERENCES spaces(id),
                       parent_id UUID REFERENCES pages(id),
                       path TEXT NOT NULL,
                       title TEXT NOT NULL,
                       current_version INT DEFAULT 1,
                       is_deleted BOOLEAN DEFAULT FALSE,
                       created_at TIMESTAMPTZ DEFAULT NOW(),
                       updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_pages_path ON pages (path text_pattern_ops);
CREATE INDEX idx_pages_space ON pages (space_id);

-- ==========================================
-- 6. PAGE VERSIONS
-- ==========================================
CREATE TABLE page_versions (
                               id UUID PRIMARY KEY,
                               page_id UUID NOT NULL REFERENCES pages(id),
                               version INT NOT NULL,
                               title TEXT NOT NULL,
                               content TEXT NOT NULL,
                               author_id UUID NOT NULL REFERENCES users(id),
                               created_at TIMESTAMPTZ DEFAULT NOW(),
                               search_vector TSVECTOR,
                               UNIQUE(page_id, version)
);
CREATE INDEX idx_page_versions_search ON page_versions USING GIN (search_vector);

-- ==========================================
-- 7. COMMENTS
-- ==========================================
CREATE TABLE comments (
                          id UUID PRIMARY KEY,
                          page_id UUID NOT NULL REFERENCES pages(id),
                          author_id UUID NOT NULL REFERENCES users(id),
                          content TEXT NOT NULL,
                          is_deleted BOOLEAN DEFAULT FALSE,
                          created_at TIMESTAMPTZ DEFAULT NOW(),
                          updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- 8. ATTACHMENTS
-- ==========================================
CREATE TABLE attachments (
                             id UUID PRIMARY KEY,
                             page_id UUID NOT NULL REFERENCES pages(id),
                             original_name VARCHAR(255) NOT NULL,
                             storage_path VARCHAR(255) NOT NULL,
                             mime_type VARCHAR(100) NOT NULL,
                             size BIGINT NOT NULL,
                             checksum_sha256 VARCHAR(64) NOT NULL,
                             author_id UUID NOT NULL REFERENCES users(id),
                             created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- 9. AUDIT LOG
-- ==========================================
CREATE TABLE audit_log (
                           id UUID PRIMARY KEY,
                           user_id UUID,
                           action VARCHAR(100) NOT NULL,
                           object_type VARCHAR(100) NOT NULL,
                           object_id UUID,
                           details JSONB,
                           created_at TIMESTAMPTZ DEFAULT NOW()
);


REVOKE UPDATE, DELETE ON audit_log FROM PUBLIC;