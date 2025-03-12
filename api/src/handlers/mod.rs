use crate::{db::Db, types::Response};
use axum::{http::HeaderMap, Extension, Json};
use uuid::Uuid;

pub mod confirm_waitlist_email;
pub mod get_repertoire;
pub mod join_waitlist;
pub mod login;
pub mod signup;

pub trait PostHandler<Input, Output> {
    async fn run(input: Input, session_token: Option<Uuid>, db: Db) -> Response<Output>;

    async fn handle(
        Extension(db): Extension<Db>,
        headers: HeaderMap,
        Json(input): Json<Input>,
    ) -> Json<Response<Output>> {
        let output = Self::run(input, session_token(&headers), db).await;
        Json(output)
    }
}

pub trait GetHandler<Input, Output> {
    async fn run(session_token: Option<Uuid>, db: Db) -> Response<Output>;

    async fn handle(Extension(db): Extension<Db>, headers: HeaderMap) -> Json<Response<Output>> {
        let output = Self::run(session_token(&headers), db).await;
        Json(output)
    }
}

fn session_token(headers: &HeaderMap) -> Option<Uuid> {
    Uuid::parse_str(
        headers
            .get("Authorization")?
            .to_str()
            .ok()?
            .strip_prefix("Bearer ")?,
    )
    .ok()
}
