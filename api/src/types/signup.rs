// Created by Fen v0.4.0 at 10:29:33 on 2025-02-12
// Do not manually modify this file as it is automatically generated

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct Input {
    pub email: String,
    pub username: String,
    pub password: String,
}

pub type Output = String;