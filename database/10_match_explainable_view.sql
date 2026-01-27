-- AppMatch
-- 10_match_explainable_view.sql
-- View explicável do match (transparência do score)

create or replace view public.match_explainable as
select
  mh.id as match_id,

  mh.profile_1,
  p1.name as profile_1_name,

  mh.profile_2,
  p2.name as profile_2_name,

  mh.final_score,

  mh.base_score,
  mh.intention_rule,
  mh.openness_rule,
  mh.rhythm_rule,
  mh.interests_weight,
  mh.age_weight,

  -- Explicações textuais
  case
    when mh.intention_rule >= 30 then 'Intenções altamente compatíveis'
    when mh.intention_rule >= 10 then 'Intenções parcialmente compatíveis'
    else 'Intenções pouco compatíveis'
  end as intention_explanation,

  case
    when mh.openness_rule >= 15 then 'Abertura emocional alinhada'
    when mh.openness_rule >= 8 then 'Abertura emocional flexível'
    else 'Diferença emocional significativa'
  end as openness_explanation,

  case
    when mh.rhythm_rule >= 10 then 'Ritmo de interação compatível'
    when mh.rhythm_rule >= 5 then 'Ritmo de interação equilibrável'
    else 'Ritmo de interação divergente'
  end as rhythm_explanation,

  mh.created_at

from public.match_history mh
join public.profiles p1 on p1.id = mh.profile_1
join public.profiles p2 on p2.id = mh.profile_2
order by mh.final_score desc;
