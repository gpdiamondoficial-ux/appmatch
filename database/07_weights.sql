-- AppMatch
-- 07_weights.sql
-- Pesos dinâmicos para cálculo de compatibilidade

create table if not exists public.match_weights (
  id uuid primary key default gen_random_uuid(),
  rule_code text not null unique,
  description text,
  weight numeric not null,
  is_active boolean default true,
  created_at timestamp with time zone default now()
);

-- =========================
-- PESOS PADRÃO (FASE 3)
-- =========================

insert into public.match_weights (rule_code, description, weight) values
  ('INTENTION_MATCH', 'Intenção igual', 1.0),
  ('INTENTION_PARTIAL', 'Uma das intenções é explorar', 0.7),
  ('INTENTION_MISMATCH', 'Intenções conflitantes', 0.2),

  ('EMOTIONAL_MATCH', 'Abertura emocional igual', 1.0),
  ('EMOTIONAL_PARTIAL', 'Abertura emocional próxima', 0.8),
  ('EMOTIONAL_MISMATCH', 'Abertura emocional distante', 0.4),

  ('RHYTHM_MATCH', 'Ritmo de interação igual', 1.0),
  ('RHYTHM_PARTIAL', 'Ritmo parcialmente compatível', 0.75),
  ('RHYTHM_MISMATCH', 'Ritmo incompatível', 0.5);
