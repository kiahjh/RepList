// Created by Fen v0.3.0 at 12:43:33 on 2025-02-06
// Do not manually modify this file as it is automatically generated

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct Input {
    pub username: String,
    pub password: String,
}

pub type Output = String;