DROP TABLE IF EXISTS member_event;
DROP TABLE IF EXISTS member_group;
DROP TABLE IF EXISTS event;
DROP TABLE IF EXISTS interest_group;
DROP TABLE IF EXISTS member;

CREATE TABLE member(
    member_id serial NOT NULL,
    name_last varchar(100) NOT NULL,
    name_first varchar(100) NOT NULL,
    email varchar(100) NOT NULL,
    phone varchar(15) NULL,  -- phone number as varchar to allow formatting flexibility
    birth_date date NOT NULL,
    flag boolean NOT NULL,  -- true for reminder emails, false otherwise
    CONSTRAINT PK_member PRIMARY KEY (member_id)
);

CREATE TABLE interest_group(
    group_id serial NOT NULL,
    name varchar(100) NOT NULL UNIQUE,
    CONSTRAINT PK_interest_group PRIMARY KEY (group_id)
);

CREATE TABLE event(
    event_id serial NOT NULL,
    name varchar(100) NOT NULL,
    description text NOT NULL,
    start timestamp NOT NULL,  -- start date and time
    duration int NOT NULL CHECK (duration >= 30),
    group_id int NOT NULL,
    CONSTRAINT PK_event PRIMARY KEY (event_id),
    CONSTRAINT FK_event_interest_group FOREIGN KEY(group_id) REFERENCES interest_group (group_id)
);

CREATE TABLE member_group(  -- associative table (many to many)
    member_id int NOT NULL,
    group_id int NOT NULL,
    CONSTRAINT PK_member_group PRIMARY KEY (member_id, group_id),
    CONSTRAINT FK_member_group_member FOREIGN KEY (member_id) REFERENCES member (member_id),
    CONSTRAINT FK_member_group_group FOREIGN KEY (group_id) REFERENCES interest_group (group_id)
);

CREATE TABLE member_event(  -- associative table (many to many)
    member_id int NOT NULL,
    event_id int NOT NULL,
    CONSTRAINT PK_member_event PRIMARY KEY (member_id, event_id),
    CONSTRAINT FK_member_event_member FOREIGN KEY (member_id) REFERENCES member (member_id),
    CONSTRAINT FK_member_event_event FOREIGN KEY (event_id) REFERENCES event (event_id)
);

-- Insert data into the member table
INSERT INTO member (name_last, name_first, email, phone, birth_date, flag)
VALUES
('Smith', 'John', 'john.smith@example.com', '1234567890', '1985-05-12', TRUE),
('Doe', 'Jane', 'jane.doe@example.com', NULL, '1990-07-23', TRUE),
('Brown', 'Charlie', 'charlie.brown@example.com', '0987654321', '1975-11-05', FALSE),
('Johnson', 'Emily', 'emily.johnson@example.com', NULL, '1999-04-17', TRUE),
('Garcia', 'Carlos', 'carlos.garcia@example.com', '5671234567', '1988-08-30', FALSE),
('Davis', 'Samantha', 'samantha.davis@example.com', NULL, '1992-09-15', TRUE),
('Martinez', 'Luis', 'luis.martinez@example.com', '7890123456', '1980-02-21', TRUE),
('Anderson', 'Nina', 'nina.anderson@example.com', '4567890123', '1995-12-08', FALSE);

-- Insert data into the interest_group table
INSERT INTO interest_group (name)
VALUES
('Book Club'),
('Hiking Enthusiasts'),
('Tech Innovators');

-- Insert data into the event table
INSERT INTO event (name, description, start, duration, group_id)
VALUES
('Monthly Book Club Meetup', 'Discussing this month’s book.', '2024-10-20 18:00', 90, 1),
('Mountain Hike', 'A full-day hike in the mountains.', '2024-10-15 08:00', 300, 2),
('Tech Conference', 'Exploring the latest innovations in tech.', '2024-10-22 09:00', 240, 3),
('Casual Hiking', 'A short hike for beginners.', '2024-10-25 10:00', 120, 2);

-- Insert data into the member_group associative table
INSERT INTO member_group (member_id, group_id)
VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 1),
(8, 2);

-- Insert data into the member_event associative table
INSERT INTO member_event (member_id, event_id)
VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4);

-- Query to check if the data is populated correctly
SELECT * FROM member;
SELECT * FROM interest_group;
SELECT * FROM event;
SELECT * FROM member_group;
SELECT * FROM member_event;