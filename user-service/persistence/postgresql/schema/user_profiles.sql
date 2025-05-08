CREATE TABLE account_profiles (
    serial_no BIGINT GENERATED ALWAYS AS IDENTITY UNIQUE,
    id UUID PRIMARY KEY,
    account_id UUID NOT NULL UNIQUE,
    first_name VARCHAR(64),
    middle_name VARCHAR(64),
    last_name VARCHAR(64),
    phone JSONB,
    avatar_url TEXT,
    profile_image_link VARCHAR(512), 
    external_id JSONB,
    language [],
    address JSONB,  
    social_accounts JSONB,
    documents JSONB,
    banking_info JSONB,
    bio JSONB, --DOB, Parents
    settings JSONB,
    preferences JSONB,      
    time_zone VARCHAR,
    identity_cards JSONB,--national_card_idVARCHAR(64),,national_card_images TEXT[], -- Array of image URLs
    image_links JSONB, -- Profile picture
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
);

ALTER TABLE account_profiles
ADD CONSTRAINT account_profiles_user_accounts_fk FOREIGN KEY (account_id)
REFERENCES user_accounts(id) ON DELETE CASCADE
