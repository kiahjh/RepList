// Created by Fen v0.5.3 at 20:08:54 on 2025-03-13
// Do not manually modify this file as it is automatically generated

use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

pub type Output = Vec<Piece>;

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
#[serde(rename_all = "camelCase")]
pub struct Piece {
    pub id: Uuid,
    pub title: String,
    pub composer: Option<String>,
    pub created_at: DateTime<Utc>,
}