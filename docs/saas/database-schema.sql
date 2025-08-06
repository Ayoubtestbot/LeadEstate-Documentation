-- =====================================================
-- LEADESTATE SAAS DATABASE SCHEMA
-- Complete subscription management system
-- =====================================================

-- 1. SUBSCRIPTION PLANS TABLE
-- Defines the available subscription tiers
CREATE TABLE IF NOT EXISTS subscription_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL, -- 'starter', 'pro', 'agency'
    display_name VARCHAR(100) NOT NULL, -- 'Starter Plan', 'Pro Plan', 'Agency Plan'
    description TEXT,
    
    -- Pricing
    monthly_price DECIMAL(10,2) NOT NULL,
    quarterly_price DECIMAL(10,2),
    semi_annual_price DECIMAL(10,2),
    annual_price DECIMAL(10,2),
    
    -- Plan limits
    max_leads INTEGER DEFAULT NULL, -- NULL = unlimited
    max_users INTEGER DEFAULT NULL, -- NULL = unlimited
    max_properties INTEGER DEFAULT NULL, -- NULL = unlimited
    
    -- Features (JSON for flexibility)
    features JSONB DEFAULT '{}', -- {"whatsapp": true, "analytics": "advanced", "branding": "full"}
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. SUBSCRIPTIONS TABLE
-- Tracks user subscriptions and billing
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    plan_id UUID NOT NULL REFERENCES subscription_plans(id),
    
    -- Subscription details
    status VARCHAR(20) NOT NULL DEFAULT 'active', -- 'trial', 'active', 'cancelled', 'expired', 'suspended'
    billing_cycle VARCHAR(20) NOT NULL, -- 'monthly', 'quarterly', 'semi_annual', 'annual'
    
    -- Trial information
    is_trial BOOLEAN DEFAULT false,
    trial_start_date TIMESTAMP,
    trial_end_date TIMESTAMP,
    trial_converted BOOLEAN DEFAULT false,
    
    -- Billing dates
    current_period_start TIMESTAMP NOT NULL,
    current_period_end TIMESTAMP NOT NULL,
    next_billing_date TIMESTAMP,
    
    -- Payment information
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_method_id VARCHAR(255), -- Stripe payment method ID
    customer_id VARCHAR(255), -- Stripe customer ID
    
    -- Subscription lifecycle
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cancelled_at TIMESTAMP,
    cancelled_reason TEXT,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_subscriptions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. BILLING HISTORY TABLE
-- Tracks all billing transactions
CREATE TABLE IF NOT EXISTS billing_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subscription_id UUID NOT NULL REFERENCES subscriptions(id),
    user_id UUID NOT NULL,
    
    -- Transaction details
    transaction_type VARCHAR(20) NOT NULL, -- 'charge', 'refund', 'failed', 'trial_start', 'trial_end'
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    
    -- Payment provider details
    provider VARCHAR(20) DEFAULT 'stripe', -- 'stripe', 'paypal'
    provider_transaction_id VARCHAR(255),
    provider_customer_id VARCHAR(255),
    
    -- Status and metadata
    status VARCHAR(20) NOT NULL, -- 'pending', 'completed', 'failed', 'refunded'
    description TEXT,
    metadata JSONB DEFAULT '{}',
    
    -- Billing period
    billing_period_start TIMESTAMP,
    billing_period_end TIMESTAMP,
    
    -- Timestamps
    processed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. TRIAL TRACKING TABLE
-- Enhanced trial user tracking for owner dashboard
CREATE TABLE IF NOT EXISTS trial_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    subscription_id UUID NOT NULL REFERENCES subscriptions(id),
    
    -- Trial details
    trial_start_date TIMESTAMP NOT NULL,
    trial_end_date TIMESTAMP NOT NULL,
    days_remaining INTEGER GENERATED ALWAYS AS (
        EXTRACT(DAY FROM (trial_end_date - CURRENT_TIMESTAMP))
    ) STORED,
    
    -- Conversion tracking
    converted BOOLEAN DEFAULT false,
    converted_at TIMESTAMP,
    converted_to_plan_id UUID REFERENCES subscription_plans(id),
    
    -- Engagement metrics
    login_count INTEGER DEFAULT 0,
    last_login_at TIMESTAMP,
    leads_created INTEGER DEFAULT 0,
    features_used JSONB DEFAULT '[]', -- Track which features they used
    
    -- Follow-up tracking
    reminder_emails_sent INTEGER DEFAULT 0,
    last_reminder_sent_at TIMESTAMP,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. FEATURE ACCESS CONTROL TABLE
-- Dynamic feature access based on subscription
CREATE TABLE IF NOT EXISTS feature_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    subscription_id UUID NOT NULL REFERENCES subscriptions(id),
    
    -- Feature permissions
    features JSONB NOT NULL DEFAULT '{}', -- Computed from plan + overrides
    
    -- Usage tracking
    current_leads_count INTEGER DEFAULT 0,
    current_users_count INTEGER DEFAULT 0,
    current_properties_count INTEGER DEFAULT 0,
    
    -- Limits (copied from plan for performance)
    max_leads INTEGER,
    max_users INTEGER,
    max_properties INTEGER,
    
    -- Last updated
    last_computed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. NOTIFICATION QUEUE TABLE
-- Automated email notifications
CREATE TABLE IF NOT EXISTS notification_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    
    -- Notification details
    type VARCHAR(50) NOT NULL, -- 'trial_started', 'trial_ending', 'trial_expired', 'payment_failed', etc.
    recipient_email VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    template_name VARCHAR(100) NOT NULL,
    template_data JSONB DEFAULT '{}',
    
    -- Scheduling
    scheduled_for TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP,
    
    -- Status
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'sent', 'failed', 'cancelled'
    attempts INTEGER DEFAULT 0,
    last_error TEXT,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. UPDATE EXISTING USERS TABLE
-- Add subscription-related fields to existing users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS subscription_id UUID REFERENCES subscriptions(id);
ALTER TABLE users ADD COLUMN IF NOT EXISTS subscription_status VARCHAR(20) DEFAULT 'trial';
ALTER TABLE users ADD COLUMN IF NOT EXISTS trial_end_date TIMESTAMP;
ALTER TABLE users ADD COLUMN IF NOT EXISTS plan_name VARCHAR(50) DEFAULT 'starter';

-- 8. INDEXES FOR PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_status ON subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_subscriptions_trial_end ON subscriptions(trial_end_date);
CREATE INDEX IF NOT EXISTS idx_billing_history_subscription ON billing_history(subscription_id);
CREATE INDEX IF NOT EXISTS idx_trial_tracking_user ON trial_tracking(user_id);
CREATE INDEX IF NOT EXISTS idx_trial_tracking_end_date ON trial_tracking(trial_end_date);
CREATE INDEX IF NOT EXISTS idx_feature_access_user ON feature_access(user_id);
CREATE INDEX IF NOT EXISTS idx_notification_queue_scheduled ON notification_queue(scheduled_for, status);

-- 9. INSERT DEFAULT SUBSCRIPTION PLANS
INSERT INTO subscription_plans (name, display_name, description, monthly_price, quarterly_price, semi_annual_price, annual_price, max_leads, max_users, features) VALUES
('starter', 'Starter Plan', 'Perfect for small agencies getting started', 99.00, 267.00, 495.00, 950.00, 1000, 3, '{"whatsapp": false, "analytics": "basic", "branding": "none", "api_access": false}'),
('pro', 'Pro Plan', 'Ideal for growing agencies with advanced needs', 199.00, 537.00, 995.00, 1900.00, 5000, 10, '{"whatsapp": true, "analytics": "advanced", "branding": "basic", "api_access": true, "google_sheets": true}'),
('agency', 'Agency Plan', 'Complete white-label solution for large agencies', 399.00, 1077.00, 1995.00, 3800.00, NULL, NULL, '{"whatsapp": true, "analytics": "enterprise", "branding": "full", "api_access": true, "google_sheets": true, "white_label": true, "custom_domain": true}')
ON CONFLICT (name) DO NOTHING;
