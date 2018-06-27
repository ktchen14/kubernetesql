DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
    user_id INT,
    name TEXT,
    email TEXT,
    manager INT
);

INSERT INTO employee
VALUES
(1, 'Sarah', 'sarah@pivotal.io', 10),
(2, 'Dhanashree', 'dhanashree@pivotal.io', 10),
(3, 'Ashuka', 'ashuka@pivotal.io', 10)
;