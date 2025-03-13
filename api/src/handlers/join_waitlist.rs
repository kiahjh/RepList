use super::PostHandler;
use crate::{
    libs::{db::Db, email::Email},
    logger::RequestLogger,
    types::Response,
};
use chrono::{DateTime, Utc};
use dotenvy_macro::dotenv;
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
                let id = Uuid::new_v4();
                let res = sqlx::query!(
                    "INSERT INTO waitlist (email, id) VALUES ($1, $2)",
                    input,
                    id
                )
                .execute(&db.pool)
                .await;

                match res {
                    Ok(_) => {
                        logger.log(&format!(
                            "{input} joined the waitlist, sending verification email..."
                        ));

                        let website_url = dotenv!("WEBSITE_URL");

                        let email = Email::new(
                            "Kiah from RepList <kiah@replist.innocencelabs.com>",
                            &input,
                            "Confirm your email",
                            format!(
                                r#"
                            <h2>Just one more step to join the waitlist!</h2>
                            <p><a href="{website_url}/confirm-email?waitlist_id={id}">Click here</a> to confirm your email.</p>"#,
                            ).trim(),
                        );
                        let res = email.send().await;
                        if let Err(e) = res {
                            logger.log(&format!("Failed to send email: {e}"));
                            return logger.res_failure(500, "Failed to send email");
                        }
                        logger.log(&format!("Email sent to {input}"));
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
