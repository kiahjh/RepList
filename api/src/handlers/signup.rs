use crate::{
    db::{tables::User, Db},
    types::{signup, Response},
};
use axum::{Extension, Json};
use bcrypt::DEFAULT_COST;

pub async fn signup(
    Extension(db): Extension<Db>,
    Json(input): Json<signup::Input>,
) -> Json<Response<signup::Output>> {
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

            Json(session_token.map_or_else(
                // if anything goes wrong when creating the token, return a 500
                |_| Response::failure(500, "Internal server error"),
                // return the token
                |session_token| Response::success(session_token.to_string()),
            ))
        }

        // user already exists but password is incorrect
        Ok(_) => Json(Response::failure(401, "User already exists")),

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

                Json(session_token.map_or_else(
                    // if anything goes wrong when creating the token, return a 500
                    |_| Response::failure(500, "Internal server error"),
                    // return the token
                    |session_token| Response::success(session_token.to_string()),
                ))
            } else {
                Json(Response::failure(500, "Internal server error"))
            }
        }

        // some other error
        Err(_) => Json(Response::failure(500, "Internal server error")),
    }
}
