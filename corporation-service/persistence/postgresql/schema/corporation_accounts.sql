
CREATE TABLE corportion_accounts (
    serial_no BIGINT GENERATED ALWAYS AS IDENTITY UNIQUE,
    id UUID PRIMARY KEY,
    api_token UUID NOT NULL, -- for service-to-service auth
    password_hash VARCHAR(256),
    active BOOLEAN DEFAULT false,
    blocked BOOLEAN DEFAULT false,
    registered BOOLEAN DEFAULT true,
    created_by UUID NOT NULL, -- created cli node.js prompt, then user_accounts user created with same id
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    last_seen TIMESTAMPTZ,
);