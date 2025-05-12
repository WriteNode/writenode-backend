CREATE TABLE user_accounts (
    serial_no BIGINT GENERATED ALWAYS AS IDENTITY UNIQUE,
    id UUID PRIMARY KEY,
    password_hash VARCHAR(256),
    corporation_id UUID NOT NULL,
    created_by UUID NOT NULL, 
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    last_seen TIMESTAMPTZ
);