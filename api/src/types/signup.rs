// Created by Fen v0.3.2 at 15:40:59 on 2025-02-11
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