-- AppMatch
-- 08_match_final.sql
-- View final de score de compatibilidade usando pesos dinâmicos

create or replace view public.match_final_scores as
with base as (
  select
    p1.id as profile_1,
    p2.id as profile_2,

    pi1.intention as intention_1,
    pi2.intention as intention_2,

    pi1.emotional_openness as openness_1,
    pi2.emotional_openness as openness_2,

    pi1.interaction_rhythm as rhythm_1,
    pi2.interaction_rhythm as rhythm_2

  from profiles p1
  join profiles p2 on p1.id < p2.id
  join profile_intentions pi1 on pi1.profile_id = p1.id
  join profile_intentions pi2 on pi2.profile_id = p2.id
),

rules as (
  select
    *,
    case
      when intention_1 = intention_2 then 'INTENTION_MATCH'
      when intention_1 = 'explorar' or intention_2 = 'explorar' then 'INTENTION_PARTIAL'
      else 'INTENTION_MISMATCH'
    end as intention_rule,

    case
      when openness_1 = openness_2 then 'EMOTIONAL_MATCH'
      else 'EMOTIONAL_PARTIAL'
    end as emotional_rule,

    case
      when rhythm_1 = rhythm_2 then 'RHYTHM_MATCH'
      else 'RHYTHM_PARTIAL'
    end as rhythm_rule
  from base
),

weights as (
  select
    r.*,
    wi.weight as intention_weight,
    we.weight as emotional_weight,
    wr.weight as rhythm_weight
  from rules r
  join match_weights wi on wi.rule_code = r.intention_rule and wi.is_active
  join match_weights we on we.rule_code = r.emotional_rule and we.is_active
  join match_weights wr on wr.rule_code = r.rhythm_rule and wr.is_active
)

select
  profile_1,
  profile_2,

  intention_rule,
  emotional_rule,
  rhythm_rule,

  intention_weight,
  emotional_weight,
  rhythm_weight,

  (intention_weight + emotional_weight + rhythm_weight) as final_score

from weights;
