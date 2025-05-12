CREATE TABLE corporation_services (
  id SERIAL PRIMARY KEY,
  corporation_id UUID NOT NULL,

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

ALTER TABLE corporation_services
ADD CONSTRAINT fk_corporation_id
FOREIGN KEY (corporation_id)
REFERENCES corportion_accounts(id) ON DELETE CASCADE;