// TODO: I think I want to get rid of this file and just inline everything

use sqlx::{Pool, Postgres};

#[derive(Clone)]
pub struct Db {
    pub pool: Pool<Postgres>,
}

impl Db {
    pub const fn new(pool: Pool<Postgres>) -> Self {
        Self { pool }
    }
}
