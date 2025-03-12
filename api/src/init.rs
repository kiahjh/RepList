use crate::{
    db::Db,
    handlers::{
        get_repertoire::GetRepertoire, join_waitlist::JoinWaitlist, login::Login, signup::Signup,
        GetHandler, PostHandler,
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
    println!("Starting server...");

    let db_url = dotenvy_macro::dotenv!("DATABASE_URL");
    println!("Database URL loaded from .env file");

    let pool = PgPoolOptions::new()
        .max_connections(20)
        .connect(db_url)
        .await
        .unwrap();
    let db = Db::new(pool);
    println!("Database connection established");

    let app = Router::new()
        .route(&fen_path("/login"), post(Login::handle))
        .route(&fen_path("/signup"), post(Signup::handle))
        .route(&fen_path("/get-repertoire"), get(GetRepertoire::handle))
        .route("/join-waitlist", post(JoinWaitlist::handle))
        .layer(Extension(db));
    println!("Routes registered");

    let listener = tokio::net::TcpListener::bind("0.0.0.0:4000").await.unwrap();
    println!("Listening on localhost:4000!\n");

    axum::serve(listener, app).await.unwrap();
}
