-- AppMatch - Database Security
-- 02 - Row Level Security & Policies

-- =========================
-- PROFILES
-- =========================

alter table public.profiles enable row level security;

create policy "Users can view own profile"
on public.profiles
for select
using (
  auth.uid() = id
);

create policy "Users can insert own profile"
on public.profiles
for insert
with check (
  auth.uid() = id
);

create policy "Users can update own profile"
on public.profiles
for update
using (
  auth.uid() = id
);

-- =========================
-- INTERESTS
-- =========================

alter table public.interests enable row level security;

create policy "Anyone can read interests"
on public.interests
for select
using (
  true
);

-- =========================
-- USER_INTERESTS
-- =========================

alter table public.user_interests enable row level security;

create policy "Users manage own interests"
on public.user_interests
for all
using (
  auth.uid() = user_id
)
with check (
  auth.uid() = user_id
);
