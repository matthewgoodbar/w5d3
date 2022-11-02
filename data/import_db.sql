
CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,
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
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    user_id INTEGER NOT NULL,
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