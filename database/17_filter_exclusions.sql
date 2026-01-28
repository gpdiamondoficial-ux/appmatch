-- =========================
-- FASE 3.6 - MATCH FILTER EXCLUSIONS
-- =========================

create or replace view match_filter_exclusions as
select
  m.profile_1,
  m.profile_2,
  'INTENTION_INCOMPATIBLE' as exclusion_reason
from match_final_scores m
join profile_intentions p1 on p1.profile_id = m.profile_1
join profile_intentions p2 on p2.profile_id = m.profile_2
where
  p1.intention <> p2.intention
  and p1.intention <> 'explorar'
  and p2.intention <> 'explorar';
