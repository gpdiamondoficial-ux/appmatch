-- 19_match_feed.sql
-- View final de entrega de matches para o app (Fase 4.1)

create or replace view public.match_feed as
select
  mf.profile_1,
  mf.profile_2,
  mf.final_score
from match_final_filtered mf
order by
  mf.final_score desc;
