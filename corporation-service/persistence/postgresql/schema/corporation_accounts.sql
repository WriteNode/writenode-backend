
CREATE TABLE corportion_accounts (
    serial_no BIGINT GENERATED ALWAYS AS IDENTITY UNIQUE,
    id UUID PRIMARY KEY,
    api_token UUID DEFAULT gen_random_uuid(), -- for service-to-service auth
    password_hash VARCHAR(256),
    active BOOLEAN DEFAULT false,
    blocked BOOLEAN DEFAULT false,
    registered BOOLEAN DEFAULT true,
    created_by BIGINT NOT NULL DEFAULT 1, 
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ,
    last_seen TIMESTAMPTZ,
);


CREATE TABLE corporation_services (
  id SERIAL PRIMARY KEY,
  corporation_id BIGINT NOT NULL REFERENCES corporations(id) ON DELETE CASCADE,

  bank_accounts JSONB,            -- multiple banks
  freight_services JSONB,         -- e.g. FedEx, DHL
  digital_financial_services JSONB, -- e.g. bKash, Stripe
  regional_domains TEXT[],        -- e.g. .com, .us, .co.jp
  software_integrations JSONB,    -- e.g. Slack, Zapier

  effective_date TIMESTAMPTZ,
  expiry_date TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ
);