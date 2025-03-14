_default:
  @just --choose

api:
  @cd api && cargo watch -x run

site:
  @cd website && pnpm run dev

# use sqlx-cli for migrations:
# - `sqlx migrate add <name>`
# - `sqlx migrate run`
# - `sqlx migrate add -r <name>` <-- reversable
# - `sqlx migrate revert`
