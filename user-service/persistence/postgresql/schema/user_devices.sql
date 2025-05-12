-- Table: user_devices
-- Purpose: Track devices used by each user, supporting uniqueness, session security,
-- auditing, push tokens, and optional MAC address if available.

CREATE TABLE user_devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Internal ID for DB

    user_id UUID NOT NULL REFERENCES user_accounts(id) ON DELETE CASCADE,
    corporation_id UUID NOT NULL, -- RLS enforcement / tenant scope

    device_id UUID NOT NULL, -- Client-side generated UUID, persistent per device
    user_agent TEXT,         -- Browser or app User-Agent string
    platform VARCHAR(50),    -- 'web', 'android', 'ios', 'desktop', etc.
    os_version VARCHAR(50),  -- e.g., 'iOS 17', 'Windows 11', 'Android 14'
    app_version VARCHAR(50), -- Your app version, for compatibility tracking

    ip_address INET,         -- Last known IP (optional)
    mac_address MACADDR,     -- Only if reliably available (optional)
    push_token TEXT,         -- For push notifications (optional)

    is_active BOOLEAN DEFAULT TRUE, -- Logical deletion or logout flag
    first_seen_at TIMESTAMPTZ DEFAULT now(),
    last_seen_at TIMESTAMPTZ,

    UNIQUE (user_id, device_id) -- Prevent duplicate devices per user
);
