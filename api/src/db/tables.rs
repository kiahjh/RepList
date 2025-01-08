use uuid::Uuid;

pub struct User {
    pub id: Uuid,
    pub username: String,
    pub hashed_password: String,
    pub email: String,
    pub composer_id: Option<Uuid>,
}
