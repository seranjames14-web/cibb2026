-- Bridgecart database setup
-- Paste this whole file into Supabase > SQL Editor > New query > Run

-- 1) Tables -----------------------------------------------------------
create table if not exists public.products (
  id          bigint generated always as identity primary key,
  name        text    not null,
  description text,
  price       numeric(10,2) not null check (price >= 0),
  image_url   text,
  created_at  timestamptz not null default now()
);

create table if not exists public.cart_items (
  id          bigint generated always as identity primary key,
  user_id     uuid   not null default auth.uid() references auth.users(id) on delete cascade,
  product_id  bigint not null references public.products(id) on delete cascade,
  quantity    int    not null default 1 check (quantity > 0),
  created_at  timestamptz not null default now(),
  unique (user_id, product_id)
);

-- 2) Row Level Security -------------------------------------------------
alter table public.products   enable row level security;
alter table public.cart_items enable row level security;

drop policy if exists "Anyone can view products" on public.products;
create policy "Anyone can view products"
  on public.products for select
  to anon, authenticated
  using (true);

drop policy if exists "Users view own cart" on public.cart_items;
create policy "Users view own cart"
  on public.cart_items for select
  to authenticated
  using (user_id = auth.uid());

drop policy if exists "Users add to own cart" on public.cart_items;
create policy "Users add to own cart"
  on public.cart_items for insert
  to authenticated
  with check (user_id = auth.uid());

drop policy if exists "Users update own cart" on public.cart_items;
create policy "Users update own cart"
  on public.cart_items for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "Users delete own cart" on public.cart_items;
create policy "Users delete own cart"
  on public.cart_items for delete
  to authenticated
  using (user_id = auth.uid());

-- 3) Access for the Data API (needed if "Automatically expose new tables" is off)
grant usage on schema public to anon, authenticated;
grant select on public.products to anon, authenticated;
grant select, insert, update, delete on public.cart_items to authenticated;

-- 4) Sample products ----------------------------------------------------
insert into public.products (name, description, price)
select * from (values
  ('Cotton T-Shirt',   'Soft everyday t-shirt',        399.00),
  ('Steel Water Bottle','1 litre, keeps drinks cold',  549.00),
  ('Wireless Earbuds', 'Bluetooth, 20h battery',      1299.00),
  ('Notebook Pack',    'Set of 3 ruled notebooks',     199.00),
  ('Phone Stand',      'Foldable desk stand',          249.00),
  ('Backpack',         '20L daily-use backpack',       899.00)
) as v(name, description, price)
where not exists (select 1 from public.products);
