use super::join_waitlist::WaitlistEntry;
use super::PostHandler;
use crate::{libs::db::Db, logger::RequestLogger, types::Response};
use uuid::Uuid;

pub struct ConfirmWaitlistEmail;

impl PostHandler<Uuid, ()> for ConfirmWaitlistEmail {
    async fn run(input: Uuid, _session_token: Option<Uuid>, db: Db) -> Response<()> {
        let logger = RequestLogger::new("ConfirmWaitlistEmail");
        logger.log(&format!("Confirming waitlist email: {input}"));

        let Ok(waitlist_entry) =
            sqlx::query_as!(WaitlistEntry, "SELECT * FROM waitlist WHERE id = $1", input)
                .fetch_optional(&db.pool)
                .await
        else {
            return logger.res_failure(500, "Failed to check waitlist");
        };

        if let Some(entry) = waitlist_entry {
            if entry.confirmed {
                logger.log(&format!("Email already confirmed: {input}"));
                return logger.res_failure(400, "Email already confirmed");
            }

            let res = sqlx::query!("UPDATE waitlist SET confirmed = true WHERE id = $1", input)
                .execute(&db.pool)
                .await;

            match res {
                Ok(_) => {
                    logger.log(&format!("Confirmed waitlist email: {input}"));
                    logger.res_success(())
                }
                Err(_) => logger.res_failure(500, "Failed to confirm waitlist email"),
            }
        } else {
            logger.log(&format!("Waitlist email not found: {input}"));
            logger.res_failure(404, "Waitlist email not found")
        }
    }
}
