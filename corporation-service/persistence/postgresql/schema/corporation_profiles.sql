CREATE TABLE corporation_profiles (
    serial_no BIGINT GENERATED ALWAYS AS IDENTITY UNIQUE,
    id UUID PRIMARY KEY,
    corporation_id UUID NOT NULL,
    external_id JSONB,
    name VARCHAR(512) NOT NULL,
    slug VARCHAR(64) UNIQUE NOT NULL,         -- e.g., "acme-corp"  
    official_name VARCHAR(512),
    contact_numbers JSONB,
    fax_numbers JSONB,
    notes TEXT,
    description JSONB,
    documents JSONB,
    language_id INT,
    currency_id INT,
    address JSONB,          -- HQ and regional offices
    brand_assets JSONB,     -- logos, banners, favicons
    social_links JSONB,     -- Twitter, LinkedIn, etc.
    corporation_licenses JSONB,
    corporation_settings JSONB,     
    tax_info JSONB,
    billing_info JSONB,    
    banking_info JSONB,
    domain_name JSONB,         
    shipping_partners JSONB,                          -- e.g., FedEx, UPS, DHL
    logistics_services JSONB,                         -- APIs or vendors used
    preferences JSONB,      
    time_zone VARCHAR,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ
);

ALTER TABLE corporation_profiles
ADD CONSTRAINT fk_corporation_id
FOREIGN KEY (corporation_id)
REFERENCES corportion_accounts(id) ON DELETE CASCADE;