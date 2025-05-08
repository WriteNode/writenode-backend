CREATE TABLE user_activations(
  id SERIAL NOT NULL PRIMARY KEY,
  account_id UUID NOT NULL,
  activation_key VARCHAR(512) NOT NULL,
  active BOOLEAN DEFAULT true,
  ip_address VARCHAR(64),
  expires_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP+ INTERVAL '3 days',
  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE,
  FOREIGN KEY (account_id) REFERENCES account (id) ON DELETE CASCADE
);