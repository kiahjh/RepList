// Created by Fen v0.5.3 at 14:55:53 on 2025-03-05
// Do not manually modify this file as it is automatically generated

pub mod get_repertoire;
pub mod login;
pub mod signup;

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "camelCase")]
pub enum Response<T> {
    Success(SuccessResponse<T>),
    Failure(FailureResponse),
}

impl<T> Response<T> {
    pub const fn success(value: T) -> Self {
        Self::Success(SuccessResponse { value })
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
    pub value: T,
}

#[derive(Serialize, Deserialize)]
pub struct FailureResponse {
    pub message: String,
    pub status: isize,
}

pub fn fen_path(path: &str) -> String {
    format!("/_fen_{path}")
}
