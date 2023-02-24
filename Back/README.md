# Back End

## Technos

Back-End:
    - Python 3.9.12
    - Flask
    - SQL Alchemy

DB:
    - PostgreSQL

## How to run

Make a copy of .env.example as .env
Modify the MODEL env variable to one of the following:
    - "125M"
    - "1.3B"
    - "2.7B"
The api will use the corresponding gpt-neo model.

Install Docker & docker-compose

Launch Docker

Run:

`
docker-compose up --build -d
`

## To test if all is working

Via Postman:

`
GET http://127.0.0.1:5000/ping
`

=> Response must be "pong"

`
GET http://127.0.0.1:5000/users
`

=> Response must be list of all users present in db

## Collection Postman

Ask member
