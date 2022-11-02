PRAGMA foreign_keys = ON;

DROP TABLE if exists question_follows;
DROP TABLE if exists question_likes;
DROP TABLE if exists replies;
DROP TABLE if exists questions;
DROP TABLE if exists users;


CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    FOREIGN KEY (user_id)
    REFERENCES users(id)
);

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    FOREIGN KEY (user_id)
    REFERENCES users(id),
    FOREIGN KEY (question_id)
    REFERENCES questions(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    body TEXT NOT NULL,
    FOREIGN KEY (question_id)
    REFERENCES questions(id),
    FOREIGN KEY (parent_id)
    REFERENCES replies(id)
);

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    FOREIGN KEY (user_id)
    REFERENCES users(id),
    FOREIGN KEY (question_id)
    REFERENCES questions(id)
);


INSERT INTO
    users (fname, lname)
VALUES  
    ('Marcos', 'Henrich'),
    ('Matthew', 'Goodbar'),
    ('Barack', 'Obama'),
    ('Tom', 'Cruise');

INSERT INTO
    questions (user_id, title, body)
VALUES
    ((SELECT id FROM users WHERE fname = 'Marcos' AND lname = 'Henrich'), 'How do I use sql?', 'Pls help' ),
    ((SELECT id FROM users WHERE fname = 'Marcos' AND lname = 'Henrich'), 'do I have covid', 'pls I am so tired'),
    ((SELECT id FROM users WHERE fname = 'Marcos' AND lname = 'Henrich'), 'why is matt so good at sql', 'what a guy'),
    ((SELECT id FROM users WHERE fname = 'Matthew' AND lname = 'Goodbar'), 'How is babby formed', 'how girl get prgent'),
    ((SELECT id FROM users WHERE fname = 'Tom' AND lname = 'Cruise'), 'How do I escape scientology prison?', 'asking for a friend');

INSERT INTO
    question_follows (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Barack' AND lname = 'Obama'),(SELECT id FROM questions WHERE title = 'How do I escape scientology prison?'));

INSERT INTO
    replies (user_id, question_id, parent_id, body)
VALUES
    ((SELECT id FROM users WHERE fname = 'Barack' AND lname = 'Obama'), (SELECT id FROM questions WHERE title = 'How do I escape scientology prison?'), NULL, 'vote lol');

INSERT INTO
    question_likes (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Tom' AND lname = 'Cruise'),(SELECT id FROM questions WHERE title = 'How do I escape scientology prison?')),
    ((SELECT id FROM users WHERE fname = 'Barack' AND lname = 'Obama'),(SELECT id FROM questions WHERE title = 'How do I escape scientology prison?')),
    ((SELECT id FROM users WHERE fname = 'Marcos' AND lname = 'Henrich'),(SELECT id FROM questions WHERE title = 'How do I escape scientology prison?')),
    ((SELECT id FROM users WHERE fname = 'Barack' AND lname = 'Obama'),(SELECT id FROM questions WHERE title = 'How is babby formed')),
    ((SELECT id FROM users WHERE fname = 'Tom' AND lname = 'Cruise'),(SELECT id FROM questions WHERE title = 'How is babby formed')),
    ((SELECT id FROM users WHERE fname = 'Matthew' AND lname = 'Goodbar'),(SELECT id FROM questions WHERE title = 'How do I use sql?')),
    ((SELECT id FROM users WHERE fname = 'Matthew' AND lname = 'Goodbar'),(SELECT id FROM questions WHERE title = 'do I have covid'));






