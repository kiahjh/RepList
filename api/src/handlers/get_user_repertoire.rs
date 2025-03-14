use super::GetHandler;
use crate::{
    libs::db::Db,
    logger::RequestLogger,
    types::{
        get_user_repertoire::{self, LearnedPiece},
        Response,
    },
};
use uuid::Uuid;

pub struct GetUserRepertoire;

impl GetHandler<(), get_user_repertoire::Output> for GetUserRepertoire {
    async fn run(session_token: Option<Uuid>, db: Db) -> Response<get_user_repertoire::Output> {
        let logger = RequestLogger::new("GetUserRepertoire");

        if session_token.is_none() {
            return logger.res_failure(401, "Unauthorized");
        }
        let session_token = session_token.unwrap();

        // get songs pertaining to user
        let songs = sqlx::query_as!(
            LearnedPiece,
            r#"
                SELECT s.id, s.title, s.composer, s.created_at, us.familiarity as "familiarity: _"
                FROM session_tokens st
                JOIN user_songs us ON st.user_id = us.user_id
                JOIN songs s ON us.song_id = s.id
                WHERE st.id = $1;
            "#,
            session_token
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
