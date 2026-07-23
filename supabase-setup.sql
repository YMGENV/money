-- Run this once in your Supabase project's SQL editor
-- (Dashboard → SQL Editor → New query → paste → Run)

create table if not exists public.accounts (
  kid text primary key,
  data jsonb not null,
  updated_at timestamptz default now()
);

create table if not exists public.challenges (
  code text primary key,
  data jsonb not null,
  updated_at timestamptz default now()
);

alter table public.accounts enable row level security;
alter table public.challenges enable row level security;

-- GoldTrack has no login/password step — the Vault ID itself is the only
-- credential — so the anon key needs open read/write access to function.
-- That means anyone who has (or finds) this anon key can read or write any
-- vault's data, not just their own. Fine for a toy/demo app; not something
-- to point at real money or real kids' data without adding real auth
-- (e.g. Supabase Auth + policies scoped to auth.uid()).

create policy "public read accounts" on public.accounts
  for select using (true);
create policy "public write accounts" on public.accounts
  for insert with check (true);
create policy "public update accounts" on public.accounts
  for update using (true);
create policy "public delete accounts" on public.accounts
  for delete using (true);

create policy "public read challenges" on public.challenges
  for select using (true);
create policy "public write challenges" on public.challenges
  for insert with check (true);
create policy "public update challenges" on public.challenges
  for update using (true);
create policy "public delete challenges" on public.challenges
  for delete using (true);
