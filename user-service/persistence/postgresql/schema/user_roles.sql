CREATE TABLE user_roles (
    id SMALLINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id UUID NOT NULL,
    role_name VARCHAR(255) NOT NULL,
    role_description TEXT, -- Optional description for the role
    permissions JSONB, -- Stores an array or object of permissions (e.g., { "create": true, "edit": false })
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expiration_date TIMESTAMP WITH TIME ZONE, -- Expiration date for the role, if any
    is_active BOOLEAN DEFAULT TRUE, -- Marks whether the role is currently active or not
    created_by UUID, -- Tracks who assigned the role (optional)
    updated_by UUID -- Tracks who updated the role (optional)
   
);
ALTER TABLE user_roles
ADD CONSTRAINT fk_user_id 
FOREIGN KEY (user_id) REFERENCES user_accounts(id) ON DELETE CASCADE;

ALTER TABLE user_roles
ADD CONSTRAINT fk_user_id_created_by
FOREIGN KEY (created_by) REFERENCES user_accounts(id) ON DELETE SET NULL;

ALTER TABLE user_roles
ADD CONSTRAINT fk_user_id_updated_by 
FOREIGN KEY (updated_by) REFERENCES user_accounts(id) ON DELETE SET NULL;

-- Optional indexes
CREATE INDEX idx_user_role_user_id ON user_role(user_id);
CREATE INDEX idx_user_role_role_name ON user_role(role_name);
CREATE INDEX idx_user_role_permissions ON user_role USING GIN (permissions);