-- Esquema relacional de la base de datos PGM Junior Alpha Monitor.
-- Este archivo define datos y fuentes; no contiene optimización de cartera.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS sources (
    source_id TEXT PRIMARY KEY,
    source_name TEXT NOT NULL,
    source_type TEXT,
    url TEXT,
    frequency TEXT,
    available_data TEXT,
    caveat TEXT
);

CREATE TABLE IF NOT EXISTS assets (
    empresa_id TEXT PRIMARY KEY,
    issuer TEXT NOT NULL,
    ticker_yahoo TEXT NOT NULL,
    ticker_local TEXT,
    exchange_name TEXT,
    operating_country TEXT,
    listing_country TEXT,
    quotation_currency TEXT,
    company_type TEXT,
    operating_stage TEXT,
    junior_flag INTEGER,
    pgm_revenue_share_pct REAL,
    pt_revenue_share_pct REAL,
    pd_revenue_share_pct REAL,
    rh_revenue_share_pct REAL,
    other_revenue_share_pct REAL,
    default_benchmark TEXT,
    risk_free_economy TEXT,
    source_id TEXT REFERENCES sources(source_id),
    data_status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS market_prices (
    price_date DATE NOT NULL,
    ticker TEXT NOT NULL,
    close_local REAL,
    close_usd REAL,
    adj_close REAL,
    volume REAL,
    market_cap_usd_m REAL,
    source_id TEXT REFERENCES sources(source_id),
    download_timestamp TEXT,
    data_status TEXT NOT NULL,
    PRIMARY KEY (price_date, ticker)
);

CREATE TABLE IF NOT EXISTS risk_free_rates (
    observation_date DATE NOT NULL,
    economy TEXT NOT NULL,
    currency TEXT NOT NULL,
    tenor_years REAL NOT NULL,
    annual_rate REAL NOT NULL,
    publication_date DATE,
    source_id TEXT REFERENCES sources(source_id),
    data_status TEXT NOT NULL,
    PRIMARY KEY (observation_date, economy, tenor_years)
);

CREATE TABLE IF NOT EXISTS market_factors (
    observation_date DATE NOT NULL,
    platinum_spot_usd_oz REAL,
    platinum_future_3m_usd_oz REAL,
    platinum_future_12m_usd_oz REAL,
    palladium_spot_usd_oz REAL,
    rhodium_spot_usd_oz REAL,
    gold_spot_usd_oz REAL,
    zar_usd REAL,
    benchmark_return REAL,
    ust_10y_pct REAL,
    vix REAL,
    source_id TEXT REFERENCES sources(source_id),
    vintage_date DATE,
    data_status TEXT NOT NULL,
    PRIMARY KEY (observation_date)
);

CREATE TABLE IF NOT EXISTS fundamentals_quarterly (
    period_end DATE NOT NULL,
    publication_date DATE NOT NULL,
    empresa_id TEXT NOT NULL REFERENCES assets(empresa_id),
    revenue_usd_m REAL,
    ebitda_usd_m REAL,
    ebitda_margin_pct REAL,
    ocf_usd_m REAL,
    capex_usd_m REAL,
    fcf_usd_m REAL,
    cash_usd_m REAL,
    gross_debt_usd_m REAL,
    short_term_debt_usd_m REAL,
    net_debt_usd_m REAL,
    net_leverage_x REAL,
    interest_cover_x REAL,
    production_4e_koz REAL,
    production_vs_guidance_pct REAL,
    realised_basket_price_usd_oz REAL,
    cash_cost_4e_usd_oz REAL,
    aisc_4e_usd_oz REAL,
    cash_cost_6e_usd_oz REAL,
    aisc_6e_usd_oz REAL,
    cost_vs_guidance_pct REAL,
    zar_usd_sensitivity_ebitda_usd_m_per_1pct REAL,
    zar_usd_sensitivity_fcf_usd_m_per_1pct REAL,
    hedge_ratio_pct REAL,
    dividends_usd_m REAL,
    buybacks_usd_m REAL,
    maturity_12m_usd_m REAL,
    maturity_24m_usd_m REAL,
    liquidity_headroom_usd_m REAL,
    source_id TEXT REFERENCES sources(source_id),
    data_status TEXT NOT NULL,
    PRIMARY KEY (period_end, empresa_id)
);

CREATE TABLE IF NOT EXISTS metal_segments_quarterly (
    period_end DATE NOT NULL,
    publication_date DATE NOT NULL,
    empresa_id TEXT NOT NULL REFERENCES assets(empresa_id),
    metal TEXT NOT NULL,
    production_oz REAL,
    revenue_usd_m REAL,
    ebitda_usd_m REAL,
    realised_price_usd_oz REAL,
    production_guidance_oz REAL,
    production_vs_guidance_pct REAL,
    source_id TEXT REFERENCES sources(source_id),
    data_status TEXT NOT NULL,
    PRIMARY KEY (period_end, empresa_id, metal)
);

CREATE TABLE IF NOT EXISTS project_pipeline (
    project_id TEXT PRIMARY KEY,
    empresa_id TEXT NOT NULL REFERENCES assets(empresa_id),
    project_name TEXT NOT NULL,
    country TEXT,
    stage TEXT,
    capex_total_usd_m REAL,
    capex_next_12m_usd_m REAL,
    production_target_4e_koz REAL,
    first_production_date DATE,
    npv_usd_m REAL,
    irr_pct REAL,
    funding_status TEXT,
    permitting_status TEXT,
    project_risk TEXT,
    source_id TEXT REFERENCES sources(source_id),
    publication_date DATE,
    data_status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS hedges (
    hedge_id TEXT PRIMARY KEY,
    empresa_id TEXT NOT NULL REFERENCES assets(empresa_id),
    period_end DATE NOT NULL,
    metal TEXT,
    instrument TEXT,
    volume_oz REAL,
    hedge_ratio_pct REAL,
    hedge_price_usd_oz REAL,
    maturity_date DATE,
    counterparty TEXT,
    source_id TEXT REFERENCES sources(source_id),
    data_status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS corporate_actions (
    action_id TEXT PRIMARY KEY,
    empresa_id TEXT NOT NULL REFERENCES assets(empresa_id),
    announcement_date DATE,
    period_end DATE,
    action_type TEXT,
    amount_usd_m REAL,
    policy_description TEXT,
    source_id TEXT REFERENCES sources(source_id),
    data_status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS operational_events (
    event_id TEXT PRIMARY KEY,
    empresa_id TEXT NOT NULL REFERENCES assets(empresa_id),
    event_date DATE NOT NULL,
    event_type TEXT NOT NULL,
    severity TEXT,
    days_disrupted REAL,
    production_lost_4e_oz REAL,
    ebitda_impact_usd_m REAL,
    status TEXT,
    source_id TEXT REFERENCES sources(source_id),
    publication_date DATE,
    data_status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS environmental_liabilities (
    observation_date DATE NOT NULL,
    empresa_id TEXT NOT NULL REFERENCES assets(empresa_id),
    rehabilitation_provision_usd_m REAL,
    closure_liability_usd_m REAL,
    water_tailings_liability_usd_m REAL,
    carbon_liability_usd_m REAL,
    probability_weight REAL,
    funded_percentage REAL,
    source_id TEXT REFERENCES sources(source_id),
    publication_date DATE,
    data_status TEXT NOT NULL,
    PRIMARY KEY (observation_date, empresa_id)
);
