// TODO: I think I want to get rid of this file and just inline everything

use crate::types::get_repertoire::Piece;
use chrono::{DateTime, Utc};
use sqlx::{Pool, Postgres};
use uuid::Uuid;

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
        let new_user =
            sqlx::query_as!( User,
            "INSERT INTO users (username, email, hashed_password) VALUES ($1, $2, $3) RETURNING *",
            username,
            email,
            hashed_password
        )
            .fetch_one(&self.pool)
            .await?;

        Ok(new_user)
    }

    pub async fn get_songs(&self, session_token: Uuid) -> Result<Vec<Piece>, sqlx::Error> {
        let songs = sqlx::query_as!(
            Piece,
            r#"
                SELECT s.id, s.title, s.composer, s.created_at, us.familiarity as "familiarity: _"
                FROM session_tokens st
                JOIN user_songs us ON st.user_id = us.user_id
                JOIN songs s ON us.song_id = s.id
                WHERE st.id = $1;
            "#,
            session_token
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(songs)
    }
}

#[derive(Debug)]
pub struct User {
    pub id: Uuid,
    pub username: String,
    pub hashed_password: String,
    pub created_at: DateTime<Utc>,
    pub email: String,
}
