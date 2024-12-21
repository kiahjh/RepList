use super::RouteResponse;
use crate::{db::Db, types::User};
use axum::{Extension, Json};
use bcrypt::DEFAULT_COST;

#[derive(serde::Deserialize)]
pub struct Input {
    username: String,
    email: String,
    password: String,
}

#[derive(serde::Serialize)]
pub struct Output {
    token: String,
}

pub async fn signup(
    Extension(db): Extension<Db>,
    Json(input): Json<Input>,
) -> Json<RouteResponse<Output>> {
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
                |_| RouteResponse::failure(4, 500, "Internal server error"),
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
        }

        // user already exists but password is incorrect
        Ok(_) => RouteResponse::failure(5, 401, "User already exists"),

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
                    |_| RouteResponse::failure(6, 500, "Internal server error"),
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
                RouteResponse::failure(6, 500, "Internal server error")
            }
        }

        // some other error
        Err(_) => RouteResponse::failure(7, 500, "Internal server error"),
    }
}
