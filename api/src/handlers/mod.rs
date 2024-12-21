use axum::Json;

pub mod login;
pub mod signup;

#[derive(serde::Serialize)]
pub enum RouteResponse<T> {
    Success {
        status: u16,
        data: T,
    },
    Failure {
        status: u16,
        code: usize,
        message: String,
    },
}

impl<T> RouteResponse<T> {
    fn failure(code: usize, status: u16, message: &str) -> Json<Self> {
        Json(Self::Failure {
            code,
            status,
            message: message.to_string(),
        })
    }

    const fn success(status: u16, data: T) -> Json<Self> {
        Json(Self::Success { status, data })
    }
}
