-- create user table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
    id int auto_increment not null,
    email varchar(255) unique not null,
    name varchar(255),
    primary key (id)
)