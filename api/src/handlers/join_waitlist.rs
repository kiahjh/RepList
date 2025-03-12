use super::PostHandler;
use crate::{db::Db, logger::RequestLogger, types::Response};
use chrono::{DateTime, Utc};
use uuid::Uuid;

pub struct JoinWaitlist;

impl PostHandler<String, ()> for JoinWaitlist {
    async fn run(input: String, _session_token: Option<Uuid>, db: Db) -> Response<()> {
        let logger = RequestLogger::new("Login");

        let res = sqlx::query_as!(
            WaitlistEntry,
            "SELECT * FROM waitlist WHERE email = $1",
            input
        )
        .fetch_optional(&db.pool)
        .await;

        match res {
            Ok(Some(_)) => {
                logger.log(&format!("Email already on waitlist: {input}"));
                logger.res_failure(400, "Email already on waitlist")
            }
            Ok(None) => {
                let res = sqlx::query!("INSERT INTO waitlist (email) VALUES ($1)", input,)
                    .execute(&db.pool)
                    .await;

                match res {
                    Ok(_) => {
                        logger.log(&format!("Joined waitlist: {input}"));
                        logger.res_success(())
                    }
                    Err(_) => logger.res_failure(500, "Failed to join waitlist"),
                }
            }
            Err(_) => logger.res_failure(500, "Failed to check waitlist"),
        }
    }
}

pub struct WaitlistEntry {
    pub email: String,
    pub id: Uuid,
    pub created_at: DateTime<Utc>,
    pub confirmed: bool,
}
