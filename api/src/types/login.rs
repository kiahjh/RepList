// Created by Fen v0.5.3 at 14:55:53 on 2025-03-05
// Do not manually modify this file as it is automatically generated

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
#[serde(rename_all = "camelCase")]
pub struct Input {
    pub username: String,
    pub password: String,
}

pub type Output = String;