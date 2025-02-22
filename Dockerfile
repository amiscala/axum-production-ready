FROM rust:bookworm as builder

WORKDIR /app

COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release --package axum-production-ready-server || true

RUN rm -rf src

COPY . .
RUN cargo build --release --package axum-production-ready-server

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/target/release/axum-production-ready-server /app/server
COPY .env /app/.env
COPY /axum-production-ready-server/private_key.pem /app/axum-production-ready-server/private_key.pem
COPY /axum-production-ready-server/public_key.pem /app/axum-production-ready-server/public_key.pem
COPY /axum-production-ready-server/server.crt /app/axum-production-ready-server/server.crt
COPY /axum-production-ready-server/server.key /app/axum-production-ready-server/server.key

CMD ["/app/server"]