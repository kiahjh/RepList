use crate::{
    db::Db,
    handlers::{login::login, signup::signup},
};
use axum::{routing::post, Extension, Router};
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
        .route("/login", post(login))
        .route("/signup", post(signup))
        .layer(Extension(db));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:4000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
