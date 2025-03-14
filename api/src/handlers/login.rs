use super::PostHandler;
use crate::{
    handlers::signup::User,
    libs::db::Db,
    logger::RequestLogger,
    types::{login, Response},
};
use uuid::Uuid;

pub struct Login;

impl PostHandler<login::Input, login::Output> for Login {
    async fn run(
        input: login::Input,
        _session_token: Option<Uuid>,
        db: Db,
    ) -> Response<login::Output> {
        let logger = RequestLogger::new("Login");

        // see if there's a user with provided username
        let user_res = sqlx::query_as!(
            User,
            "SELECT * FROM users WHERE username = $1",
            input.username
        )
        .fetch_one(&db.pool)
        .await;

        match user_res {
            // user exists
            Ok(user) => {
                if bcrypt::verify(input.password, &user.hashed_password).unwrap_or(false) {
                    // if the password is correct, then create a token
                    // note that this safely ignores the case that there's already an existing token;
                    // in that case the user would just switch to the new token, and the old token will
                    // get expired eventually
                    let session_token = sqlx::query!(
                        "INSERT INTO session_tokens (user_id) VALUES ($1) RETURNING id",
                        user.id
                    )
                    .fetch_one(&db.pool)
                    .await;

                    session_token.map_or_else(
                        // if anything goes wrong when creating the token, return a 500
                        |_| logger.res_failure(500, "Failure creating session token"),
                        // return the token
                        |session_token| logger.res_success(session_token.id.to_string()),
                    )
                } else {
                    // if the password is incorrect, return a 401
                    logger.res_failure(401, "Incorrect password")
                }
            }

            // user doesn't exist
            Err(sqlx::Error::RowNotFound) => logger.res_failure(404, "User not found"),

            // some other error
            Err(_) => logger.res_failure(500, "Internal server error"),
        }
    }
}
