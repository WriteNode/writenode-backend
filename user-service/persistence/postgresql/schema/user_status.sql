CREATE TABLE user_status (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    corporation_id UUID NOT NULL, 
    profile_completed BOOLEAN DEFAULT FALSE,
    subscribed BOOLEAN DEFAULT FALSE,
    subscriptions JSONB,
     active BOOLEAN DEFAULT false,
    blocked BOOLEAN DEFAULT false,
    registered BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

ALTER TABLE user_status
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id)
REFERENCES user_accounts(id);