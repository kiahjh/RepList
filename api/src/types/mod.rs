// Created by Fen v0.1.0 at 15:15:58 on 2025-01-08
// Do not manually modify this file as it is automatically generated

pub mod signup;
pub mod login;

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
#[serde(tag = "type")]
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
