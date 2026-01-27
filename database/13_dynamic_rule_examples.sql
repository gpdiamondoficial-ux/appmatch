-- AppMatch
-- 13_dynamic_rule_examples.sql
-- Fase 3.4: Regras dinâmicas reais de matching

-- =========================
-- LIMPAR REGRAS ANTIGAS (DEV)
-- =========================
delete from dynamic_match_rules;

-- =========================
-- REGRA 1: Penalidade por match repetido
-- =========================
insert into dynamic_match_rules (
  rule_key,
  description,
  rule_type,
  value,
  active
)
values (
  'repeat_match_penalty',
  'Penaliza perfis que já deram match anteriormente',
  'penalty',
  10,
  true
);

-- =========================
-- REGRA 2: Boost para intenção rara
-- =========================
insert into dynamic_match_rules (
  rule_key,
  description,
  rule_type,
  value,
  active
)
values (
  'rare_intention_boost',
  'Aumenta score quando ambos buscam relacionamento sério',
  'boost',
  15,
  true
);

-- =========================
-- REGRA 3: Penalidade por baixa abertura emocional
-- =========================
insert into dynamic_match_rules (
  rule_key,
  description,
  rule_type,
  value,
  active
)
values (
  'low_emotional_openness_penalty',
  'Reduz score se ambos forem emocionalmente reservados',
  'penalty',
  5,
  true
);
