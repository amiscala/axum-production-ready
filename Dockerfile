FROM rust:bookworm as builder

WORKDIR /app


COPY . .
RUN cargo build --release --package axum-production-ready-server

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/target/release/axum-production-ready-server /app/server
COPY .env /app/.env
COPY /axum-production-ready-server/private_key.pem /app/axum-production-ready-server/private_key.pem
COPY /axum-production-ready-server/private_key.pem /app/axum-production-ready-server/public_key.pem
COPY server.crt /app/axum-production-ready-server/server.crt
COPY server.key /app/axum-production-ready-server/server.key

CMD ["/app/server"]