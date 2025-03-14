use super::PostHandler;
use crate::{
    libs::db::Db,
    logger::RequestLogger,
    types::{signup, Response},
};
use bcrypt::DEFAULT_COST;
use chrono::{DateTime, Utc};
use uuid::Uuid;

pub struct Signup;

impl PostHandler<signup::Input, signup::Output> for Signup {
    async fn run(
        input: signup::Input,
        _session_token: Option<Uuid>,
        db: Db,
    ) -> Response<signup::Output> {
        let logger = RequestLogger::new("Signup");

        // see if there's a user with provided username
        let user_res = sqlx::query_as!(
            User,
            "SELECT * FROM users WHERE email = $1 AND username = $2",
            input.email,
            input.username
        )
        .fetch_one(&db.pool)
        .await;

        match user_res {
            // user already exists and password is correct, so we just log them in
            Ok(user) if bcrypt::verify(&input.password, &user.hashed_password).unwrap_or(false) => {
                // create a token
                let session_token = sqlx::query!(
                    "INSERT INTO session_tokens (user_id) VALUES ($1) RETURNING id",
                    user.id
                )
                .fetch_one(&db.pool)
                .await;

                session_token.map_or_else(
                    // if anything goes wrong when creating the token, return a 500
                    |_| logger.res_failure(500, "Failed to create session token"),
                    // return the token
                    |session_token| logger.res_success(session_token.id.to_string()),
                )
            }

            // user already exists but password is incorrect
            Ok(_) => logger.res_failure(401, "User already exists"),

            // user doesn't exist, so we create a new user
            Err(sqlx::Error::RowNotFound) => {
                let new_user = sqlx::query_as!(
                    User,
                    "INSERT INTO users (username, email, hashed_password) VALUES ($1, $2, $3) RETURNING *",
                    &input.username,
                    &input.email,
                    &bcrypt::hash(&input.password, DEFAULT_COST).unwrap(),
                )
                .fetch_one(&db.pool)
                .await;

                if let Ok(new_user) = new_user {
                    let session_token = sqlx::query!(
                        "INSERT INTO session_tokens (user_id) VALUES ($1) RETURNING id",
                        new_user.id
                    )
                    .fetch_one(&db.pool)
                    .await;

                    session_token.map_or_else(
                        // if anything goes wrong when creating the token, return a 500
                        |_| logger.res_failure(500, "Failed to create session token"),
                        // return the token
                        |session_token| logger.res_success(session_token.id.to_string()),
                    )
                } else {
                    dbg!(new_user.unwrap_err());
                    logger.res_failure(500, "Failed to create user")
                }
            }

            // some other error
            Err(_) => logger.res_failure(500, "Failed to find user"),
        }
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
