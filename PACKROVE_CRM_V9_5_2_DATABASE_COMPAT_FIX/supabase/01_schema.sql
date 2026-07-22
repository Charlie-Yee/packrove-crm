create extension if not exists pgcrypto;

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  platform text default '', country text default '', city text default '', website text default '', instagram text default '', email text default '', contact_name text default '',
  customer_type text default '', customer_pool text not null default '未建联' check (customer_pool in ('未建联','已建联')),
  target_product text default '', recommended_product text default '', outreach_angle text default '',
  level text not null default 'C' check (level in ('A','B','C')),
  stage text not null default '需求确认', touch_status text not null default '未联系',
  profile text default '', grade_reason text default '', requirement text default '', quantity text default '', budget text default '', concern text default '',
  next_action text default '', next_follow date, probability integer default 0 check (probability between 0 and 100), notes text default '', last_contact date,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.timeline (
  id bigint generated always as identity primary key, customer_id uuid not null references public.customers(id) on delete cascade,
  event_date date not null default current_date, event_type text default '跟进', content text not null, created_at timestamptz not null default now()
);
create table if not exists public.quotations (
  id uuid primary key default gen_random_uuid(), customer_id uuid not null references public.customers(id) on delete cascade,
  quote_no text not null unique, product text default '', quantity numeric default 0, unit_price numeric default 0, amount numeric default 0, currency text default 'USD',
  issue_date date default current_date, valid_until date, status text default '草稿', notes text default '', created_at timestamptz default now(), updated_at timestamptz default now()
);
create table if not exists public.pi_documents (
  id uuid primary key default gen_random_uuid(), customer_id uuid not null references public.customers(id) on delete cascade, quotation_id uuid references public.quotations(id) on delete set null,
  pi_no text not null unique, amount numeric default 0, currency text default 'USD', payment_method text default 'T/T', issue_date date default current_date, status text default '待确认', created_at timestamptz default now()
);
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(), customer_id uuid not null references public.customers(id) on delete cascade, pi_id uuid references public.pi_documents(id) on delete set null,
  order_no text not null unique, product text default '', quantity text default '', amount numeric default 0, currency text default 'USD', payment_status text default '待付款', production_status text default '待生产', delivery_date date, created_at timestamptz default now()
);
create table if not exists public.shipments (
  id uuid primary key default gen_random_uuid(), order_id uuid not null references public.orders(id) on delete cascade,
  method text default '', tracking_no text default '', eta date, status text default '待发货', created_at timestamptz default now()
);
create index if not exists customers_next_follow_idx on public.customers(next_follow);
create index if not exists customers_pool_idx on public.customers(customer_pool);
create index if not exists customers_stage_idx on public.customers(stage);
create index if not exists timeline_customer_idx on public.timeline(customer_id,event_date desc);

create or replace function public.set_updated_at() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end $$;
drop trigger if exists customers_updated_at on public.customers;
create trigger customers_updated_at before update on public.customers for each row execute function public.set_updated_at();
drop trigger if exists quotations_updated_at on public.quotations;
create trigger quotations_updated_at before update on public.quotations for each row execute function public.set_updated_at();
