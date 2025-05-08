CREATE TABLE user_scopes (
    id SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    corporation_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ
);
