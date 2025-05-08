CREATE TABLE user_accounts (
    serial_no BIGINT GENERATED ALWAYS AS IDENTITY UNIQUE,
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    password_hash VARCHAR(256),
    corporation_id UUID NOT NULL,
    active BOOLEAN DEFAULT false,
    blocked BOOLEAN DEFAULT false,
    registered BOOLEAN DEFAULT true,
    --user_type_id SMALLINT NOT NULL DEFAULT 'General',
    created_by BIGINT NOT NULL DEFAULT 1, 
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    last_seen TIMESTAMPTZ
);

ALTER TABLE user_accounts
ADD CONSTRAINT user_accounts_user_identities_fk FOREIGN KEY (user_id)
REFERENCES user_identities(id) ON DELETE CASCADE

-- ALTER TABLE user_accounts
-- ADD CONSTRAINT user_accounts_user_user_types_fk FOREIGN KEY (user_type_id)
-- REFERENCES user_types(id) ON DELETE CASCADE;
