CREATE TABLE user_types (
    id SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    corporation_id UUID NOT NULL,
    code VARCHAR(64) UNIQUE NOT NULL, -- Short code like 'student', 'nurse'
    label VARCHAR(255) NOT NULL, -- Display-friendly label
    name VARCHAR(255) NOT NULL,
    description TEXT, -- Optional human-readable description
    category VARCHAR(128), -- e.g., "Healthcare", "Education", "Retail"
    tags TEXT[], -- Optional: e.g., ['on-site', 'verified']
    metadata JSONB, -- Extensible structured metadata for future APIs
    is_active BOOLEAN DEFAULT TRUE,
    is_system BOOLEAN DEFAULT FALSE, -- Mark as system-defined (not user-created)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

