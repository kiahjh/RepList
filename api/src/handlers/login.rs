use super::RouteResponse;
use crate::{db::Db, types::User};
use axum::{Extension, Json};

#[derive(serde::Deserialize)]
pub struct Input {
    username: String,
    password: String,
}

#[derive(serde::Serialize)]
pub struct Output {
    token: String,
}

#[axum::debug_handler]
pub async fn login(
    Extension(db): Extension<Db>,
    Json(input): Json<Input>,
) -> Json<RouteResponse<Output>> {
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
                let session_token = db.create_session_token(user.id).await;

                session_token.map_or_else(
                    // if anything goes wrong when creating the token, return a 500
                    |_| RouteResponse::failure(0, 500, "Internal server error"),
                    // return the token
                    |session_token| {
                        RouteResponse::success(
                            200,
                            Output {
                                token: session_token.to_string(),
                            },
                        )
                    },
                )
            } else {
                // if the password is incorrect, return a 401
                RouteResponse::failure(1, 401, "Invalid password")
            }
        }

        // user doesn't exist
        Err(sqlx::Error::RowNotFound) => RouteResponse::failure(2, 404, "User not found"),

        // some other error
        Err(_) => RouteResponse::failure(3, 500, "Internal server error"),
    }
}
