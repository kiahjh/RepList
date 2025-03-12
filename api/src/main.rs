#![allow(dead_code)] // TODO: remove this line
use init::run;

mod handlers;
mod init;
mod libs;
mod logger;
mod types;

#[tokio::main]
async fn main() {
    run().await;
}
