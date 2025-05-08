CREATE TABLE user_role_scopes (
    corporation_id UUID NOT NULL,
    role_id SMALLINT NOT NULL REFERENCES user_roles(id) ON DELETE CASCADE,
    scope_id SMALLINT NOT NULL REFERENCES user_scopes(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, scope_id),
    
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ
);