CREATE TABLE corporation_status (
    serial_no BIGINT GENERATED ALWAYS AS IDENTITY UNIQUE,
    id BIGINT PRIMARY KEY,
    corporation_id UUID NOT NULL,   
    profile_completed BOOLEAN DEFAULT FALSE,
    subscribed BOOLEAN DEFAULT FALSE,
    corporation_subscriptions JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

ALTER TABLE corporation_status
ADD CONSTRAINT fk_corporation_id
FOREIGN KEY (corporation_id)
REFERENCES corportion_accounts(id);