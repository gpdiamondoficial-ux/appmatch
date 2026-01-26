-- AppMatch
-- 12_score_adjustments.sql
-- Fase 3.3: Aplicação de regras dinâmicas ao score final

-- =========================
-- VIEW: AJUSTES APLICÁVEIS
-- =========================

create or replace view public.match_rule_adjustments as
select
  m.profile_1,
  m.profile_2,
  r.rule_key,
  r.rule_type,
  r.value as rule_value,
  case
    when r.rule_type = 'penalty' then -r.value
    else r.value
  end as applied_value
from match_final_scores m
cross join dynamic_match_rules r
where r.active = true;

-- =========================
-- TABELA: SCORE AJUSTADO
-- =========================

create table if not exists public.match_adjusted_scores (
  id uuid primary key default gen_random_uuid(),

  profile_1 uuid not null,
  profile_2 uuid not null,

  base_score integer not null,
  adjustment integer not null,
  final_score integer not null,

  created_at timestamp with time zone default now()
);

-- =========================
-- INSERT: APLICAR AJUSTES
-- =========================

insert into public.match_adjusted_scores (
  profile_1,
  profile_2,
  base_score,
  adjustment,
  final_score
)
select
  m.profile_1,
  m.profile_2,
  m.final_score as base_score,
  coalesce(sum(a.applied_value), 0) as adjustment,
  m.final_score + coalesce(sum(a.applied_value), 0) as final_score
from match_final_scores m
left join match_rule_adjustments a
  on a.profile_1 = m.profile_1
 and a.profile_2 = m.profile_2
group by
  m.profile_1,
  m.profile_2,
  m.final_score;
