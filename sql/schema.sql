-- SaaS mini schema (Postgres)

CREATE TABLE IF NOT EXISTS users (
  user_id           BIGSERIAL PRIMARY KEY,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  country           TEXT NOT NULL,
  marketing_channel TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS plans (
  plan_id        BIGSERIAL PRIMARY KEY,
  name           TEXT NOT NULL UNIQUE,
  price_usd      NUMERIC(10,2) NOT NULL,
  billing_period TEXT NOT NULL CHECK (billing_period IN ('monthly','yearly'))
);

CREATE TABLE IF NOT EXISTS subscriptions (
  subscription_id BIGSERIAL PRIMARY KEY,
  user_id         BIGINT NOT NULL REFERENCES users(user_id),
  plan_id         BIGINT NOT NULL REFERENCES plans(plan_id),
  status          TEXT NOT NULL CHECK (status IN ('active','canceled','past_due')),
  started_at      TIMESTAMPTZ NOT NULL,
  cancelled_at    TIMESTAMPTZ NULL,
  ended_at        TIMESTAMPTZ NULL,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_updated_at ON subscriptions(updated_at);

CREATE TABLE IF NOT EXISTS invoices (
  invoice_id       BIGSERIAL PRIMARY KEY,
  subscription_id  BIGINT NOT NULL REFERENCES subscriptions(subscription_id),
  amount_usd       NUMERIC(10,2) NOT NULL,
  currency         TEXT NOT NULL DEFAULT 'USD',
  status           TEXT NOT NULL CHECK (status IN ('issued','paid','failed','void')),
  issued_at        TIMESTAMPTZ NOT NULL,
  paid_at          TIMESTAMPTZ NULL,
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_invoices_subscription_id ON invoices(subscription_id);
CREATE INDEX IF NOT EXISTS idx_invoices_updated_at ON invoices(updated_at);

CREATE TABLE IF NOT EXISTS events (
  event_id     BIGSERIAL PRIMARY KEY,
  user_id      BIGINT NOT NULL REFERENCES users(user_id),
  event_type   TEXT NOT NULL,
  event_ts     TIMESTAMPTZ NOT NULL,
  properties   JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS idx_events_user_id ON events(user_id);
CREATE INDEX IF NOT EXISTS idx_events_event_ts ON events(event_ts);

-- Incremental export state (for Lambda → S3 later)
CREATE TABLE IF NOT EXISTS etl_watermarks (
  source_name  TEXT PRIMARY KEY,
  last_ts      TIMESTAMPTZ NOT NULL
);