-- 2. Identities (Email, Phone, OAuth, Username)
CREATE TABLE user_identities (
    serial_no BIGINT GENERATED ALWAYS AS IDENTITY UNIQUE,
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    corporation_id UUID NOT NULL,
    identity_type VARCHAR(256) NOT NULL, -- email / phone / username / google / apple / etc
    identity_value VARCHAR(256) NOT NULL,
    external_id VARCHAR(256) UNIQUE,
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

ALTER TABLE user_identities
ADD CONSTRAINT fk_user_id 
FOREIGN KEY (user_id)
REFERENCES user_accounts(id) ON DELETE CASCADE;

ALTER TABLE user_identities
ADD CONSTRAINT uq_identity_type_value 
UNIQUE (identity_type, identity_value);