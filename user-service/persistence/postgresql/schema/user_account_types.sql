CREATE TABLE user_account_types (
    --id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES user_accounts(id) ON DELETE CASCADE,
    user_type_id UUID NOT NULL REFERENCES user_types(id) ON DELETE CASCADE,
    assigned_at TIMESTAMPTZ DEFAULT now(),
    assigned_by UUID, -- optional: could be an admin user
    metadata JSONB,
    PRIMARY KEY (user_id, user_type_id)
);