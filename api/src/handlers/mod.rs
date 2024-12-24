use axum::Json;
use serde::{ser::SerializeStruct, Serialize, Serializer};

pub mod login;
pub mod signup;

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

impl<T> Serialize for RouteResponse<T>
where
    T: Serialize,
{
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        match self {
            Self::Success { status, data } => {
                let mut state = serializer.serialize_struct("RouteResponse", 3)?;
                state.serialize_field("success", &true)?;
                state.serialize_field("status", &status)?;
                state.serialize_field("data", &data)?;
                state.end()
            }
            Self::Failure {
                status,
                code,
                message,
            } => {
                let mut state = serializer.serialize_struct("RouteResponse", 4)?;
                state.serialize_field("success", &false)?;
                state.serialize_field("status", &status)?;
                state.serialize_field("code", &code)?;
                state.serialize_field("message", &message)?;
                state.end()
            }
        }
    }
}
