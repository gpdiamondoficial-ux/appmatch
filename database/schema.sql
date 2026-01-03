-- AppMatch - Database Schema
-- Fase 1 - Estrutura inicial

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  birth_date date,
  gender text,
  created_at timestamp with time zone default now()
);

alter table public.profiles enable row level security;

create policy "Users can view own profile"
on public.profiles
for select
using (auth.uid() = id);

create policy "Users can insert own profile"
on public.profiles
for insert
with check (auth.uid() = id);

create policy "Users can update own profile"
on public.profiles
for update
using (auth.uid() = id);


create table public.interests (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text,
  created_at timestamp with time zone default now()
);

alter table public.interests enable row level security;

create policy "Anyone can read interests"
on public.interests
for select
using (true);


create table public.user_interests (
  user_id uuid references public.profiles(id) on delete cascade,
  interest_id uuid references public.interests(id) on delete cascade,
  created_at timestamp with time zone default now(),
  primary key (user_id, interest_id)
);

alter table public.user_interests enable row level security;

create policy "Users manage own interests"
on public.user_interests
for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

