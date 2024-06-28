-- create user table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
    id int auto_increment not null,
    email varchar(255) unique not null,
    name varchar(255),
    country ENUM('US', 'CO', 'TN') not null default 'US',
    primary key (id)
)