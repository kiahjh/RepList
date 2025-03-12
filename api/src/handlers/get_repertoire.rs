use uuid::Uuid;

use super::GetHandler;
use crate::{
    libs::db::Db,
    logger::RequestLogger,
    types::{get_repertoire, Response},
};

pub struct GetRepertoire;

impl GetHandler<(), get_repertoire::Output> for GetRepertoire {
    async fn run(session_token: Option<Uuid>, db: Db) -> Response<get_repertoire::Output> {
        let logger = RequestLogger::new("GetRepertoire");

        if session_token.is_none() {
            return logger.res_failure(401, "Unauthorized");
        }
        let session_token = session_token.unwrap();

        // get songs pertaining to user
        let songs_res = db.get_songs(session_token).await;

        // return them if it works
        songs_res.map_or_else(
            |_| logger.res_failure(500, "Failed to get songs"),
            |songs| logger.res_success(songs),
        )
    }
}
