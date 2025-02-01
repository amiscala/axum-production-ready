# Axum Production Ready

This project was made to showcase a Axum with a custom authentication based on scopes and proper Open Telemetry
observability, please adapt
and use as you need.
It is a simples Todo List App where we have a user, which could have a password for login, but the idea here is to be
an API and the user is just to bind the clients to some business entity.
It uses Postgresql with [sqlx](https://docs.rs/sqlx/latest/sqlx/)

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

5. Run the docker compose file (the App may take a while to be available, it will await all the initialization of
   Postgresql DB on the docker compose).

## Requests

### `Postman`

* Collection on the root of the project with the
  name [axum-production-ready-server.postman_collection.json](https://github.com/amiscala/axum-production-ready/blob/master/axum-production-ready-server.postman_collection.json)

### cURL

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
3. Users:
    1. Create User And Client:
       ```curl
          curl --location 'https://localhost:4000/user/create-user-and-client' \
             --header 'Content-Type: application/json' \
             --data-raw '{
             "email":"new@test.com",
             "name":"Example",
             "last_name":"User"
             }'
       ``` 
    2. Get User:
       ```curl
       curl --location 'https://localhost:4000/user' \
       --header 'Authorization: Bearer TOKEN'
       ```
    3. Update User:
          ```curl
          curl --location --request PUT 'https://localhost:4000/user' \
       --header 'Content-Type: application/json' \
       --header 'Authorization: Bearer Token' \
       --data-raw '{
       "email":"updated@email.com",
       "name":"Updated Name",
       "last_name":"Updated Last Name"
       }'
       ```
    4. Delete User (Warning this will also delete the client and you will no longer be able to issue tokens):
       ```curl
       curl --location --request PUT 'https://localhost:4000/user' \
          --header 'Content-Type: application/json' \
          --header 'Authorization: Bearer Token' \
          --data-raw '{
          "email":"updated@email.com",
          "name":"Updated Name",
          "last_name":"Updated Last Name"
          }'
          ```
4. Todos:
    1. Create new Todo:
       ```curl
          curl --location 'https://localhost:4000/todo' \
          --header 'Content-Type: application/json' \
          --header 'Authorization: Bearer TOKEN' \
          --data '{
             "title":"My First TODO",
             "body": "The body of my todo, it can be any string",
             "category":"Development"
          }'
       ``` 
    2. Get Todo By Id:
       ```curl
       curl --location 'https://localhost:4000/todo/{todo_id}' \
       --header 'Authorization: Bearer TOKEN'
       ```
    3. Update Todo by Id:
          ```curl
          curl --location --request PUT 'https://localhost:4000/todo' \
          --header 'Content-Type: application/json' \
          --header 'Authorization: Bearer TOKEN' \
          --data '{
             "todo_id":"todo_id",
             "title":"My TODO new Title",
             "body": "My new TODO body of my todo, it can be any string",
             "category":"UX",
             "status": "COMPLETED"
          }'
       ```
    4. Get all todos for the user:
       ```curl
          curl --location 'https://localhost:4000/todo/todos' \
          --header 'Authorization: Bearer TOKEN'
       ```    
    5. Delete Todo by Id:
       ```curl
          curl --location --request DELETE 'https://localhost:4000/todo/{todo_id}' \
          --header 'Authorization: Bearer Token'
       ```                          
5. Client:
    1. Create new Client:
       ```curl
          curl --location 'https://localhost:4000/client' \
          --header 'Content-Type: application/json' \
          --header 'Authorization: Bearer TOKEN' \
          --data '{
             "client_scopes":"read write admin",
             "client_description": "My Client Description"
             
          }'
       ``` 
    2. Get Client By Id:
       ```curl
          curl --location 'https://localhost:4000/client/{client_id}' \
          --header 'Authorization: Bearer TOKEN'
       ```
    3. Update Client by Id:
          ```curl
          curl --location --request PUT 'https://localhost:4000/client' \
          --header 'Content-Type: application/json' \
          --header 'Authorization: Bearer TOKEN' \
          --data '{
             "client_id":"{client_id}",
             "client_description":"New description for the client",
             "client_scopes":"admin read write"
             
          }'
       ```
    4. Get all clients for the user:
       ```curl
          curl --location --request PUT 'https://localhost:4000/client' \
          --header 'Content-Type: application/json' \
          --header 'Authorization: Bearer TOKEN' \
          --data '{
             "client_id":"{client_id}",
             "client_description":"New description for the client",
             "client_scopes":"admin read write"
             
          }'
       ```    
    5. Delete Todo by Id:
       ```curl
          curl --location --request DELETE 'https://localhost:4000/client/0194c3b6-3b16-7bd2-8d2b-227a0f65fe3b' \
          --header 'Authorization: Bearer TOKEN'
       ```                          
            
         
