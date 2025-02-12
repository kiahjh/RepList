// Created by Fen v0.4.0 at 10:29:33 on 2025-02-12
// Do not manually modify this file as it is automatically generated

pub mod get_repertoire;
pub mod signup;
pub mod login;

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "camelCase")]
pub enum Response<T> {
    Success(SuccessResponse<T>),
    Failure(FailureResponse),
}

impl<T> Response<T> {
    pub const fn success(data: T) -> Self {
        Self::Success(SuccessResponse { data })
    }

    pub fn failure(status: isize, message: &str) -> Self {
        Self::Failure(FailureResponse {
            status,
            message: message.to_string(),
        })
    }
}

#[derive(Serialize, Deserialize)]
pub struct SuccessResponse<T> {
    pub data: T,
}

#[derive(Serialize, Deserialize)]
pub struct FailureResponse {
    pub message: String,
    pub status: isize,
}

pub fn fen_path(path: &str) -> String {
    format!("/_fen_{path}")
}
