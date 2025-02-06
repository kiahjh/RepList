use super::PostHandler;
use crate::{
    db::{Db, User},
    logger::RequestLogger,
    types::{signup, Response},
};
use bcrypt::DEFAULT_COST;
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
                let session_token = db.create_session_token(user.id).await;

                session_token.map_or_else(
                    // if anything goes wrong when creating the token, return a 500
                    |_| logger.res_failure(500, "Failed to create session token"),
                    // return the token
                    |session_token| logger.res_success(session_token.to_string()),
                )
            }

            // user already exists but password is incorrect
            Ok(_) => logger.res_failure(401, "User already exists"),

            // user doesn't exist, so we create a new user
            Err(sqlx::Error::RowNotFound) => {
                let new_user = db
                    .create_user(
                        &input.username,
                        &input.email,
                        &bcrypt::hash(&input.password, DEFAULT_COST).unwrap(),
                    )
                    .await;

                if let Ok(new_user) = new_user {
                    let session_token = db.create_session_token(new_user.id).await;

                    session_token.map_or_else(
                        // if anything goes wrong when creating the token, return a 500
                        |_| logger.res_failure(500, "Failed to create session token"),
                        // return the token
                        |session_token| logger.res_success(session_token.to_string()),
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
