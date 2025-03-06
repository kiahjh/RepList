// Created by Fen v0.5.3 at 14:55:53 on 2025-03-05
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
    pub familiarity: FamiliarityLevel,
    pub composer: Option<String>,
    pub created_at: DateTime<Utc>,
}

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq, sqlx::Type)]
#[serde(tag = "type", rename_all = "camelCase")]
#[sqlx(type_name = "familiarity_level", rename_all = "SCREAMING_SNAKE_CASE")]
pub enum FamiliarityLevel {
    Todo,
    Learning,
    Playable,
    Good,
    Mastered,
}