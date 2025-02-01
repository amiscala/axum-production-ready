# Axum Production Ready

This project was made to showcase a Axum with a custom authentication and proper observability, please  adapt
and use as you need.


# Running:
1. Clone this repo and all it´s submodules with:
`git clone --recursive https://github.com/amiscala/axum-production-ready.git`
2. Go to the project root folder:
`cd axum-production-ready`
3. Generate the public and private keys for jwt signing.
```bash
openssl genrsa -out private_key.pem 2048 && openssl rsa -in private_key.pem -pubout -out public_key.pem
```
4. Generate the certificate and private key for the server SSL
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt
```

5. Run the docker compose file.
6. Use those requests:
   1. First create a user and client with this request (this endpoint is public):
   ```curl
   curl --location 'https://localhost:4000/user/create-user-and-client' \
    --header 'Content-Type: application/json' \
    --data-raw '{
    "email":"email@email.com",
    "name":"Example",
    "last_name":"Example"
    }'
   ```
   2. Then issue a access token to be used on the other requests:
   ```curl
   curl --location 'https://localhost:4000/authentication/token' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data-urlencode 'client_id=The Client Id from the previous response' \
    --data-urlencode 'client_secret=The Client Secret from the previous response' \
    --data-urlencode 'grant_type=client_credentials' \
    --data-urlencode 'scope=read write admin'
   ```
