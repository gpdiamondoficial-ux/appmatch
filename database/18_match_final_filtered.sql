-- =========================
-- FASE 3.6 - FINAL MATCH WITH FILTERS
-- =========================

create or replace view match_final_filtered as
select
  f.*
from match_final_scores f
left join match_filter_exclusions e
  on e.profile_1 = f.profile_1
 and e.profile_2 = f.profile_2
where e.profile_1 is null;
