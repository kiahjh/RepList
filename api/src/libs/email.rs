use dotenvy_macro::dotenv;
use resend_rs::{
    types::{CreateEmailBaseOptions, CreateEmailResponse},
    Resend, Result,
};

pub struct Email {
    pub from: String,
    pub to: String,
    pub subject: String,
    pub html: String,
}

impl Email {
    pub fn new(from: &str, to: &str, subject: &str, html: &str) -> Self {
        Self {
            from: from.to_string(),
            to: to.to_string(),
            subject: subject.to_string(),
            html: html.to_string(),
        }
    }

    pub async fn send(&self) -> Result<CreateEmailResponse> {
        let resend_api_key = dotenv!("RESEND_API_KEY");
        let resend = Resend::new(resend_api_key);

        let email = CreateEmailBaseOptions::new(&self.from, [&self.to], &self.subject)
            .with_html(&self.html);

        resend.emails.send(email).await
    }
}
