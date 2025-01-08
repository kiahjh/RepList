// Created by Fen v0.1.0 at 15:15:58 on 2025-01-08
// Do not manually modify this file as it is automatically generated

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Input {
    pub email: String,
    pub username: String,
    pub password: String,
}

pub type Output = String;