# Bridgecart

A simple shopping cart app: login, product list, and a cart saved in Supabase.

## Files
- `schema.sql`  – database tables, security rules, sample products
- `index.html`  – the whole app (open it in a browser)

## Setup (3 steps)

### 1. Create the tables
1. Supabase → your **Bridgecart** project → **SQL Editor** → **New query**
2. Paste everything from `schema.sql` → tap **Run**
3. Check **Table Editor**: you should see `products` (6 rows) and `cart_items`

### 2. Add your key
1. Supabase → **Project Settings → API Keys** → copy the **Publishable key** (`sb_publishable_...`)
2. Open `index.html`, find `SUPABASE_KEY` near the bottom, replace `PASTE_PUBLISHABLE_KEY_HERE` with your key
3. Never paste the **Secret key** anywhere in this file.

### 3. Put it online (GitHub Pages)
1. Upload `index.html`, `schema.sql`, `README.md` to your GitHub repo
2. Repo → **Settings → Pages** → Source: **Deploy from a branch** → Branch: `main` / root → **Save**
3. After ~1 minute your app is at `https://<your-username>.github.io/<repo-name>/`

## Notes
- New accounts must confirm their email first (Supabase default). To skip that while testing:
  Supabase → **Authentication → Sign In / Providers → Email** → turn off **Confirm email**.
- Supabase → **Authentication → URL Configuration** → set **Site URL** to your GitHub Pages address.
