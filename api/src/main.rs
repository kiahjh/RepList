#![allow(dead_code)] // TODO: remove this line
use init::run;

mod db;
mod handlers;
mod init;
mod types;

#[tokio::main]
async fn main() {
    run().await;
}
