-- AppMatch
-- 01_schema.sql
-- Estrutura das tabelas principais

create table public.profiles (
  id uuid not null,
  name text not null,
  birth_date date,
  gender text,
  created_at timestamp with time zone default now(),
  constraint profiles_pkey primary key (id),
  constraint profiles_id_fkey foreign key (id)
    references auth.users(id) on delete cascade
);

create table public.interests (
  id uuid not null default gen_random_uuid(),
  name text not null,
  category text,
  interest_type text not null,
  base_weight integer not null,
  created_at timestamp with time zone default now(),
  constraint interests_pkey primary key (id)
);

create table public.user_interests (
  user_id uuid not null,
  interest_id uuid not null,
  created_at timestamp with time zone default now(),
  constraint user_interests_pkey primary key (user_id, interest_id),
  constraint user_interests_user_id_fkey foreign key (user_id)
    references public.profiles(id) on delete cascade,
  constraint user_interests_interest_id_fkey foreign key (interest_id)
    references public.interests(id) on delete cascade
);

create table public.user_preferences (
  id uuid not null default gen_random_uuid(),
  profile_id uuid not null,
  min_age integer,
  max_age integer,
  prefers_gender text,
  likes_beach boolean default false,
  likes_travel boolean default false,
  likes_sports boolean default false,
  created_at timestamp without time zone default now(),
  constraint user_preferences_pkey primary key (id),
  constraint user_preferences_profile_id_fkey foreign key (profile_id)
    references public.profiles(id) on delete cascade
);

create table public.profile_intentions (
  id uuid not null default gen_random_uuid(),
  profile_id uuid not null unique,
  intention intention_enum not null,
  emotional_openness emotional_openness_enum not null,
  interaction_rhythm interaction_rhythm_enum not null,
  open_to_local boolean default true,
  open_to_travel boolean default false,
  prefer_chat_first boolean default true,
  prefer_in_person boolean default false,
  created_at timestamp with time zone default now(),
  constraint profile_intentions_pkey primary key (id),
  constraint profile_intentions_profile_id_fkey foreign key (profile_id)
    references public.profiles(id) on delete cascade
);
