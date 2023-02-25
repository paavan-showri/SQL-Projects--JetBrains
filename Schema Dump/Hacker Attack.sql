                                                -- Hacker Attack ( For SQLite CLI)


-- Use code blocks one by one in SQLite Command Line Interface

.print " The following data is available person.csv teacher.csv score1.csv score2.csv score3.csv "

.print "Create person table"

CREATE TABLE "person"(                          --  Person Table created                        
  "person_id" VARCHAR(9) PRIMARY KEY,
  "full_name" TEXT,
  "address" TEXT,
  "building_number" TEXT,
  "phone_number" TEXT
);

.mode csv                                       --  .mode - Set output mode to CSV

.import --skip 1 person.csv person_id           --  .import - Import data from FILE into TABLE

.mode column                                    --  .mode - Set output mode to COLUMN

.print "Now create teacher table"

CREATE TABLE "teacher"(
  "person_id" VARCHAR(9) PRIMARY KEY,
  "class_code" TEXT
);

.mode csv

.import --skip 1 teacher.csv teacher

.mode column

.print "Select every record from the person table that is missing in the teacher table. This will give the student's list"

SELECT person_id, full_name FROM person
WHERE
person_id not in
(SELECT person_id FROM teacher)
ORDER BY full_name LIMIT 5;

.print "create the student table and fill it with data"

CREATE TABLE student(
    person_id VARCHAR(9) PRIMARY KEY,
    grade_code TEXT
);

INSERT INTO
    student(person_id)
SELECT person_id FROM person
WHERE
person_id not in
(SELECT person_id FROM teacher)

.print "Create three tables. With the name score1, score2, and score3"

CREATE TABLE score1(
   "person_id" VARCHAR(9),
   "score" INTEGER
);

CREATE TABLE score2(
   "person_id" VARCHAR(9),
   "score" INTEGER
);

CREATE TABLE score3(
   "person_id" VARCHAR(9),
   "score" INTEGER
);

.print("Select all the data from the score tables and merge them together with the UNION ALL command")

.mode csv

.import --skip 1 score1.csv score1

.import --skip 1 score2.csv score2

.import --skip 1 score3.csv score3

.mode column

SELECT * FROM score1
UNION ALL
SELECT * FROM score2
UNION ALL
SELECT * FROM score3;

.print "Insert the scores into the score table. Delete score1, score2, and score3 tables with the DROP command"

CREATE TABLE score(
   "person_id" VARCHAR(9),
   "score" INTEGER
);

INSERT INTO
    score(person_id,score)
SELECT * FROM score1
UNION ALL
SELECT * FROM score2
UNION ALL
SELECT * FROM score3;

DROP TABLE score1;

DROP TABLE score2;

DROP TABLE score3;


.print "If there is no score in the score table, the grade code is GD-09"
.print "If the score count is 1 in the score table, the grade code is GD-10"
.print "If the score count is 2 in the score table, the grade code is GD-11"
.print "If the score count is 3 in the score table, the grade code will be GD-12"


UPDATE student
SET grade_code = "GD-09"
WHERE student.person_id not in
    (SELECT person_id FROM score
    GROUP BY person_id
    ORDER BY person_id);

UPDATE student
SET grade_code = "GD-10"
WHERE student.person_id in
    (SELECT person_id FROM score
    GROUP BY person_id
    HAVING count(score) = 1
    ORDER BY person_id);

UPDATE student
SET grade_code = "GD-11"
WHERE student.person_id in
    (SELECT person_id FROM score
    GROUP BY person_id
    HAVING count(score) = 2
    ORDER BY person_id);

UPDATE student
SET grade_code = "GD-12"
WHERE student.person_id in
    (SELECT person_id FROM score
    GROUP BY person_id
    HAVING count(score) = 3
    ORDER BY person_id);


SELECT * FROM student
ORDER BY person_id
LIMIT 5;

.print "Calculate the average score for the last-year students who have grade code GD-12 in the student table "

SELECT person_id,ROUND(AVG(score),2) as avg_score FROM score
WHERE person_id in (SELECT person_id FROM student WHERE grade_code = "GD-12" GROUP BY person_id)
GROUP BY person_id
ORDER BY avg_score DESC;