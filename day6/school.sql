PRAGMA foreign_keys = ON;
-- Create the students table
CREATE TABLE students (
    student_id TEXT PRIMARY KEY,
    student_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);
-- Create the courses table
CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY,
    course_name TEXT NOT NULL UNIQUE
);
-- Create the enrolments table
CREATE TABLE enrolments (
    enrolment_id INTEGER PRIMARY KEY,
    student_id TEXT NOT NULL,
    course_id INTEGER NOT NULL,
    grade TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    UNIQUE (student_id, course_id)
);

INSERT INTO students (student_id, student_name, email) VALUES
('003', 'Amina', 'amina@example.com'),
('005', 'Brian', 'brian@example.com'),
('001', 'Carol', 'carol@example.com');

INSERT INTO courses (course_id, course_name) VALUES
(1, 'Database Systems'),
(2, 'Web Development'),
(3, 'Computer Networks');

INSERT INTO enrolments (enrolment_id, student_id, course_id, grade) VALUES
(1, '003', 1, 'A'),
(2, '003', 2, 'B'),
(3, '005', 1, 'B'),
(4, '005', 3, 'A'),
(5, '001', 2, 'A');


-- Query: Find all courses taken by Amina
SELECT
    students.student_name,
    courses.course_name,
    enrolments.grade
FROM students
JOIN enrolments
    ON students.student_id = enrolments.student_id
JOIN courses
    ON enrolments.course_id = courses.course_id
WHERE students.student_name = 'Amina';

-- Query: Find all students taking Database Systems
SELECT
    courses.course_name,
    students.student_name
FROM courses
JOIN enrolments
    ON courses.course_id = enrolments.course_id
JOIN students
    ON enrolments.student_id = students.student_id
WHERE courses.course_name = 'Database Systems';

-- QUERY 3: Count the number of students per course
SELECT
    courses.course_name,
    COUNT(enrolments.student_id) AS student_count
FROM courses
LEFT JOIN enrolments
    ON courses.course_id = enrolments.course_id
GROUP BY courses.course_id, courses.course_name;

-- QUERY 4: Find students who have no enrolments
SELECT
    students.student_id,
    students.student_name
FROM students
LEFT JOIN enrolments
    ON students.student_id = enrolments.student_id
WHERE enrolments.enrolment_id IS NULL;

-- QUERY 5: Update Brian's grade for Database Systems
UPDATE enrolments
SET grade = 'A'
WHERE enrolment_id = 3;

-- Verify the updated grade
SELECT
    students.student_name,
    courses.course_name,
    enrolments.grade
FROM enrolments
JOIN students
    ON enrolments.student_id = students.student_id
JOIN courses
    ON enrolments.course_id = courses.course_id
WHERE enrolments.enrolment_id = 3;