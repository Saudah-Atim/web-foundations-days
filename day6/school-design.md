# School Database Design

# 1. Students Table

The students table stores information about each student. It contains a student ID, student name, and email address. The student ID is the primary key, which means every student has a unique ID. The student name and email are required, and the email address must be unique.

# 2. Courses Table

The courses table stores information about the courses offered by the school. It contains a course ID and course name. The course ID is the primary key, and the course name is required and must be unique.

# 3. Enrolments Table

The enrolments table records the courses taken by students and their grades. It contains an enrolment ID, student ID, course ID, and grade. The student ID and course ID are foreign keys that reference the students and courses tables. A student cannot enrol in the same course twice because the combination of student ID and course ID must be unique.

# 4. Relationships

Students and enrolments have a one-to-many relationship because one student can enrol in several courses, but each enrolment belongs to one student.

Courses and enrolments also have a one-to-many relationship because one course can have many students, but each enrolment refers to one course.

Students and courses have a many-to-many relationship because a student can take several courses and each course can have several students. The enrolments table is needed as a join table to connect students and courses and store each student's grade.

# 5. Index

I would add an index on the course ID in the enrolments table to make it faster to find all students enrolled in a particular course. This would also help when counting the students taking each course.

Example SQL:

CREATE INDEX idx_enrolments_course_id
ON enrolments(course_id);

# 6. SQL or NoSQL?

I would choose SQL for this school database because the data is structured and the tables have clear relationships. SQL supports primary keys, foreign keys, unique constraints, and JOIN operations, which help keep the data accurate and make it easy to retrieve information about students, courses, and grades.