use sqlx::{Pool, Postgres};
use tables::User;
use uuid::Uuid;

pub mod tables;

#[derive(Clone)]
pub struct Db {
    pub pool: Pool<Postgres>,
}

impl Db {
    pub const fn new(pool: Pool<Postgres>) -> Self {
        Self { pool }
    }

    pub async fn create_session_token(&self, user_id: Uuid) -> Result<Uuid, sqlx::Error> {
        let session_token = sqlx::query!(
            "INSERT INTO session_tokens (user_id) VALUES ($1) RETURNING id",
            user_id
        )
        .fetch_one(&self.pool)
        .await?;

        Ok(session_token.id)
    }

    pub async fn create_user(
        &self,
        username: &str,
        email: &str,
        hashed_password: &str,
    ) -> Result<User, sqlx::Error> {
        let new_user = sqlx::query_as!(
            User,
            "INSERT INTO users (username, email, hashed_password) VALUES ($1, $2, $3) RETURNING *",
            username,
            email,
            hashed_password
        )
        .fetch_one(&self.pool)
        .await?;

        Ok(new_user)
    }
}
