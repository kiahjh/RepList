use crate::{
    db::Db,
    handlers::{
        get_repertoire::GetRepertoire, login::Login, signup::Signup, GetHandler, PostHandler,
    },
    types::fen_path,
};
use axum::{
    routing::{get, post},
    Extension, Router,
};
use sqlx::postgres::PgPoolOptions;

pub static mut DB: Option<Db> = None;

pub async fn run() {
    let pool = PgPoolOptions::new()
        .max_connections(20)
        .connect("postgres://postgres:local@localhost:5432/replist_dev")
        .await
        .unwrap();
    let db = Db::new(pool);

    let app = Router::new()
        .route(&fen_path("/login"), post(Login::handle))
        .route(&fen_path("/signup"), post(Signup::handle))
        .route(&fen_path("/get-repertoire"), get(GetRepertoire::handle))
        .layer(Extension(db));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:4000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
