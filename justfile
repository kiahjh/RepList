_default:
  @just --choose

api:
	@cd api && cargo watch -x run

gt:
  @marsh gt marsh/types.marsh rust ./api/src/types.rs

# use sqlx-cli for migrations:
# - `sqlx migrate add <name>`
# - `sqlx migrate run`
# - `sqlx migrate add -r <name>` <-- reversable
# - `sqlx migrate revert`
