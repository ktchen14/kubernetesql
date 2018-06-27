DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
    user_id INT,
    name TEXT,
    email TEXT,
    manager INT
);

INSERT INTO employee
VALUES
(1, 'Melanie', 'mplageman@pivotal.io', 10),
(2, 'Dhanashree', 'dkashid@pivotal.io', 10),
(3, 'Ashuka', 'axue@pivotal.io', 10),
(10, 'Kaiting', 'kaitingc@vmware.com', 20)
;

DROP TABLE IF EXISTS cves;
CREATE TABLE cves (
    id TEXT,
    description TEXT,
    docker_image TEXT
);

INSERT INTO cves VALUES
('CVE-2018-7000', 'A security issue in nginx', 'nginx:1.7.9'),
('CVE-2018-8000', 'A problem with apache', 'library/apache'),
('CVE-2018-9000', 'Something bad with postgresql', 'postgres:9.3.23')
;
