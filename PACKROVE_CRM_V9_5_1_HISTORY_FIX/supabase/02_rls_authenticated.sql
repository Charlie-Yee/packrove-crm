alter table public.customers enable row level security;
alter table public.timeline enable row level security;
alter table public.quotations enable row level security;
alter table public.pi_documents enable row level security;
alter table public.orders enable row level security;
alter table public.shipments enable row level security;

do $$ declare t text; begin
  foreach t in array array['customers','timeline','quotations','pi_documents','orders','shipments'] loop
    execute format('drop policy if exists authenticated_all on public.%I',t);
    execute format('create policy authenticated_all on public.%I for all to authenticated using (true) with check (true)',t);
  end loop;
end $$;
