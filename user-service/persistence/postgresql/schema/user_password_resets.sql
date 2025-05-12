CREATE TABLE user_password_resets (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    corporation_id UUID NOT NULL,
    reset_token VARCHAR(512) NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL '12 hours'),
    consumed BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

ALTER TABLE user_password_resets
ADD CONSTRAINT fk_user_id 
FOREIGN KEY (user_id)
REFERENCES user_accounts(id) ON DELETE CASCADE;