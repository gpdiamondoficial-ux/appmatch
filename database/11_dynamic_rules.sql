-- AppMatch
-- 11_dynamic_rules.sql
-- Fase 3.2: Regras dinâmicas de matching (penalties e boosts)

-- =========================
-- TABELA DE REGRAS DINÂMICAS
-- =========================

create table if not exists public.dynamic_match_rules (
  id uuid primary key default gen_random_uuid(),

  rule_key text not null unique,
  description text not null,

  rule_type text not null check (rule_type in ('penalty', 'boost')),

  value integer not null,
  active boolean default true,

  created_at timestamp with time zone default now()
);

-- =========================
-- COMENTÁRIOS (DOCUMENTAÇÃO)
-- =========================

comment on table public.dynamic_match_rules is
'Tabela de regras dinâmicas que ajustam o score final de matching';

comment on column public.dynamic_match_rules.rule_key is
'Identificador lógico da regra (ex: repeat_match_penalty)';

comment on column public.dynamic_match_rules.rule_type is
'Tipo da regra: penalty reduz score, boost aumenta score';

comment on column public.dynamic_match_rules.value is
'Valor aplicado ao score (positivo ou negativo conforme rule_type)';
