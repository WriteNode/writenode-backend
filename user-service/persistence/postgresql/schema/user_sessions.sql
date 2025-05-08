CREATE TABLE user_sessions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  session_key VARCHAR,
  token_hash VARCHAR,
  refresh_token_hash TEXT NOT NULL,
  active BOOLEAN DEFAULT true,
  issued_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at TIMESTAMPTZ NOT NULL,
  ip_address INET,
  revoked_at TIMESTAMPTZ,
  metadata JSONB,  -- optional: device info, OS, geo, etc.
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE user_sessions
ADD CONSTRAINT fk_user_id 
FOREIGN KEY (user_id)
REFERENCES user_accounts(id) ON DELETE CASCADE;