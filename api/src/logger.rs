use colored::Colorize;
use uuid::Uuid;

use crate::types::Response;

#[allow(clippy::module_name_repetitions)]
pub struct RequestLogger {
    route: String,
    request_id: Uuid,
}

impl RequestLogger {
    pub fn new(route: &str) -> Self {
        let new_logger = Self {
            route: route.to_string(),
            request_id: Uuid::new_v4(),
        };
        new_logger.log("Received request");
        new_logger
    }

    pub fn log(&self, message: &str) {
        println!(
            "{} {} ({})\n> \"{}\"",
            self.route.bold().magenta(),
            self.request_id,
            chrono::Local::now().format("%Y-%m-%d %H:%M:%S:%3f"),
            message
        );
    }

    pub fn success(&self) {
        self.log(&"Request successful".italic().green());
    }

    pub fn failure(&self, message: &str) {
        self.log(&message.italic().red());
    }

    pub fn res_failure<T>(&self, status: isize, message: &str) -> Response<T> {
        self.failure(message);
        Response::failure(status, message)
    }

    pub fn res_success<T>(&self, data: T) -> Response<T> {
        self.success();
        Response::success(data)
    }
}
