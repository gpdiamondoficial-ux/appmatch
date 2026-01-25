-- AppMatch
-- 09_match_history.sql
-- Histórico de matches gerados pelo sistema

create table if not exists public.match_history (
  id uuid primary key default gen_random_uuid(),

  profile_1 uuid not null,
  profile_2 uuid not null,

  final_score integer not null,

  base_score integer,
  intention_rule integer,
  openness_rule integer,
  rhythm_rule integer,
  interests_weight integer,
  age_weight integer,

  created_at timestamp with time zone default now(),

  constraint match_history_profile_1_fkey
    foreign key (profile_1) references public.profiles(id) on delete cascade,

  constraint match_history_profile_2_fkey
    foreign key (profile_2) references public.profiles(id) on delete cascade,

  constraint unique_match_pair
    unique (profile_1, profile_2)
);
