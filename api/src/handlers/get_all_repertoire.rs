use super::GetHandler;
use crate::{
    libs::db::Db,
    logger::RequestLogger,
    types::{
        get_all_repertoire::{self, Piece},
        Response,
    },
};
use uuid::Uuid;

pub struct GetAllRepertoire;

impl GetHandler<(), get_all_repertoire::Output> for GetAllRepertoire {
    async fn run(session_token: Option<Uuid>, db: Db) -> Response<get_all_repertoire::Output> {
        let logger = RequestLogger::new("GetAllRepertoire");

        if session_token.is_none() {
            return logger.res_failure(401, "Unauthorized");
        }
        let session_token = session_token.unwrap();

        // verify that session token is valid
        let session_token =
            sqlx::query!("SELECT id FROM session_tokens WHERE id = $1", session_token)
                .fetch_one(&db.pool)
                .await;
        if session_token.is_err() {
            return logger.res_failure(401, "Unauthorized");
        }
        // now we know the session token is valid

        // get all songs
        let songs = sqlx::query_as!(
            Piece,
            r#"
                SELECT s.id, s.title, s.composer, s.created_at
                FROM songs s;
            "#
        )
        .fetch_all(&db.pool)
        .await;

        // return them if it works
        songs.map_or_else(
            |_| logger.res_failure(500, "Failed to get songs"),
            |songs| logger.res_success(songs),
        )
    }
}
