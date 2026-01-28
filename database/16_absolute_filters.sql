-- =========================
-- FASE 3.6 - ABSOLUTE FILTER RULES
-- =========================

-- Regra: intenção incompatível elimina match
insert into dynamic_match_rules (
  rule_key,
  description,
  rule_type,
  value,
  active
) values (
  'incompatible_intention',
  'Elimina match quando intenções são incompatíveis',
  'filter',
  0,
  true
);

-- Regra: bloqueio explícito (placeholder futuro)
insert into dynamic_match_rules (
  rule_key,
  description,
  rule_type,
  value,
  active
) values (
  'explicit_block',
  'Elimina match quando existe bloqueio explícito entre perfis',
  'filter',
  0,
  true
);
