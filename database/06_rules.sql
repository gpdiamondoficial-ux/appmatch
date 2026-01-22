-- AppMatch
-- 06_rules.sql
-- Regras absolutas e eventos base

-- =========================================
-- FASE 3.2 — REGRAS CONDICIONAIS DE MATCHING
-- =========================================

CREATE TABLE IF NOT EXISTS matching_rules (
    id SERIAL PRIMARY KEY,
    rule_name TEXT NOT NULL,
    description TEXT,
    condition_type TEXT NOT NULL, -- ex: intention, interest, openness
    condition_value TEXT NOT NULL,
    score_adjustment INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO matching_rules (
    rule_name,
    description,
    condition_type,
    condition_value,
    score_adjustment
) VALUES
(
    'Intenção compatível séria',
    'Aumenta score quando ambos buscam relacionamento sério',
    'intention',
    'relacionamento_serio',
    20
),
(
    'Intenção conflitante',
    'Reduz score quando intenções são incompatíveis',
    'intention',
    'conflito',
    -30
);

