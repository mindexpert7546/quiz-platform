USE exam_prep;

-- Starter seed data: 2 exams, 2 subjects per exam, 2 quiz sets per subject, 5 questions per set.

START TRANSACTION;

INSERT INTO exams (name, code, description, status, created_at, updated_at)
VALUES
  ('General Aptitude Exam', 'EXAM001', 'Sample exam for general aptitude practice.', 'ACTIVE', NOW(), NOW()),
  ('Technical Knowledge Exam', 'EXAM002', 'Sample exam for technical knowledge practice.', 'ACTIVE', NOW(), NOW());

SET @exam1 = (SELECT id FROM exams WHERE code = 'EXAM001');
SET @exam2 = (SELECT id FROM exams WHERE code = 'EXAM002');

INSERT INTO subjects (exam_id, name, description, status, created_at, updated_at)
VALUES
  (@exam1, 'Mathematics', 'Mathematics practice for aptitude.', 'ACTIVE', NOW(), NOW()),
  (@exam1, 'English', 'English language practice and grammar.', 'ACTIVE', NOW(), NOW()),
  (@exam2, 'General Knowledge', 'General awareness and current affairs.', 'ACTIVE', NOW(), NOW()),
  (@exam2, 'Computer Fundamentals', 'Basic computer knowledge.', 'ACTIVE', NOW(), NOW());

SET @math1 = (SELECT id FROM subjects WHERE exam_id = @exam1 AND name = 'Mathematics');
SET @english1 = (SELECT id FROM subjects WHERE exam_id = @exam1 AND name = 'English');
SET @gk2 = (SELECT id FROM subjects WHERE exam_id = @exam2 AND name = 'General Knowledge');
SET @comp2 = (SELECT id FROM subjects WHERE exam_id = @exam2 AND name = 'Computer Fundamentals');

INSERT INTO topics (exam_id, subject_id, name, description, status, created_at, updated_at)
VALUES
  (@exam1, @math1, 'Numbers and Algebra', 'Core math concepts for aptitude.', 'ACTIVE', NOW(), NOW()),
  (@exam1, @english1, 'Vocabulary and Grammar', 'English vocabulary, grammar, and usage.', 'ACTIVE', NOW(), NOW()),
  (@exam2, @gk2, 'Current Affairs', 'General knowledge and current affairs topics.', 'ACTIVE', NOW(), NOW()),
  (@exam2, @comp2, 'Computer Basics', 'Fundamental computer science concepts.', 'ACTIVE', NOW(), NOW());

SET @topicMath1 = (SELECT id FROM topics WHERE subject_id = @math1);
SET @topicEnglish1 = (SELECT id FROM topics WHERE subject_id = @english1);
SET @topicGk2 = (SELECT id FROM topics WHERE subject_id = @gk2);
SET @topicComp2 = (SELECT id FROM topics WHERE subject_id = @comp2);

INSERT INTO difficulty_levels (name, sort_order, created_at, updated_at)
VALUES
  ('Easy', 1, NOW(), NOW()),
  ('Medium', 2, NOW(), NOW()),
  ('Hard', 3, NOW(), NOW());

INSERT INTO question_types (name, created_at, updated_at)
VALUES
  ('Multiple Choice', NOW(), NOW());

INSERT INTO quizzes (exam_id, subject_id, topic_id, name, set_name, set_number, duration_minutes, option_count, total_marks, passing_marks, access_type, status, created_at, updated_at)
VALUES
  (@exam1, @math1, @topicMath1, 'Mathematics Set 1', 'Math Set 1', 1, 15, 4, 5, 3, 'FREE', 'PUBLISHED', NOW(), NOW()),
  (@exam1, @math1, @topicMath1, 'Mathematics Set 2', 'Math Set 2', 2, 15, 4, 5, 3, 'FREE', 'PUBLISHED', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 'English Set 1', 'English Set 1', 1, 15, 4, 5, 3, 'FREE', 'PUBLISHED', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 'English Set 2', 'English Set 2', 2, 15, 4, 5, 3, 'FREE', 'PUBLISHED', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 'General Knowledge Set 1', 'GK Set 1', 1, 15, 4, 5, 3, 'FREE', 'PUBLISHED', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 'General Knowledge Set 2', 'GK Set 2', 2, 15, 4, 5, 3, 'FREE', 'PUBLISHED', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 'Computer Fundamentals Set 1', 'Comp Set 1', 1, 15, 4, 5, 3, 'FREE', 'PUBLISHED', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 'Computer Fundamentals Set 2', 'Comp Set 2', 2, 15, 4, 5, 3, 'FREE', 'PUBLISHED', NOW(), NOW());

SET @mathQuiz1 = (SELECT id FROM quizzes WHERE exam_id = @exam1 AND subject_id = @math1 AND set_number = 1);
SET @mathQuiz2 = (SELECT id FROM quizzes WHERE exam_id = @exam1 AND subject_id = @math1 AND set_number = 2);
SET @englishQuiz1 = (SELECT id FROM quizzes WHERE exam_id = @exam1 AND subject_id = @english1 AND set_number = 1);
SET @englishQuiz2 = (SELECT id FROM quizzes WHERE exam_id = @exam1 AND subject_id = @english1 AND set_number = 2);
SET @gkQuiz1 = (SELECT id FROM quizzes WHERE exam_id = @exam2 AND subject_id = @gk2 AND set_number = 1);
SET @gkQuiz2 = (SELECT id FROM quizzes WHERE exam_id = @exam2 AND subject_id = @gk2 AND set_number = 2);
SET @compQuiz1 = (SELECT id FROM quizzes WHERE exam_id = @exam2 AND subject_id = @comp2 AND set_number = 1);
SET @compQuiz2 = (SELECT id FROM quizzes WHERE exam_id = @exam2 AND subject_id = @comp2 AND set_number = 2);

INSERT INTO questions (exam_id, subject_id, topic_id, difficulty_level_id, question_type_id, question_text, optiona, optionb, optionc, optiond, optione, correct_answer, explanation, marks, status, created_at, updated_at)
VALUES
  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 1 Q1: What is 7 + 8?', '12', '13', '14', '15', NULL, 'B', 'Basic addition', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 1 Q2: What is 6 x 5?', '25', '30', '35', '40', NULL, 'B', 'Multiplication', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 1 Q3: What is 15 - 9?', '5', '6', '7', '8', NULL, 'B', 'Subtraction', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 1 Q4: 4 + 9 = ?', '11', '12', '13', '14', NULL, 'A', 'Addition', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 1 Q5: 18 ÷ 3 = ?', '4', '5', '6', '7', NULL, 'C', 'Division', 1, 'ACTIVE', NOW(), NOW()),

  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 2 Q1: What is 9 + 12?', '18', '19', '20', '21', NULL, 'C', 'Addition', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 2 Q2: What is 8 x 4?', '24', '28', '32', '36', NULL, 'A', 'Multiplication', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 2 Q3: 20 - 7 = ?', '11', '12', '13', '14', NULL, 'C', 'Subtraction', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 2 Q4: 6 + 6 = ?', '10', '11', '12', '13', NULL, 'C', 'Addition', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @math1, @topicMath1, 1, 1, 'Math Set 2 Q5: 30 ÷ 5 = ?', '5', '6', '7', '8', NULL, 'A', 'Division', 1, 'ACTIVE', NOW(), NOW()),

  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 1 Q1: Choose the correct word: I ___ a book.', 'am', 'is', 'are', 'was', NULL, 'A', 'Present tense', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 1 Q2: Choose the correct plural: child', 'childs', 'children', 'childes', 'childrens', NULL, 'B', 'Plural noun', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 1 Q3: Choose the correct article: ___ apple.', 'A', 'An', 'The', 'No article', NULL, 'B', 'Article usage', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 1 Q4: Synonym of quick is ___.', 'slow', 'rapid', 'ugly', 'hard', NULL, 'B', 'Synonym', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 1 Q5: Choose the correct tense: She ___ to school.', 'go', 'goes', 'gone', 'going', NULL, 'B', 'Verb form', 1, 'ACTIVE', NOW(), NOW()),

  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 2 Q1: Choose the opposite of happy.', 'sad', 'tall', 'fast', 'easy', NULL, 'A', 'Antonym', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 2 Q2: Fill in the blank: I have ___ apples.', 'a', 'an', 'some', 'any', NULL, 'C', 'Quantifier', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 2 Q3: Choose the correct form: They ___ playing.', 'is', 'are', 'am', 'be', NULL, 'B', 'Verb agreement', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 2 Q4: The word "book" is a ___.', 'verb', 'adjective', 'noun', 'adverb', NULL, 'C', 'Parts of speech', 1, 'ACTIVE', NOW(), NOW()),
  (@exam1, @english1, @topicEnglish1, 1, 1, 'English Set 2 Q5: Choose the correct preposition: The pen is ___ the table.', 'in', 'on', 'at', 'over', NULL, 'B', 'Preposition', 1, 'ACTIVE', NOW(), NOW()),

  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 1 Q1: What is the capital of France?', 'Rome', 'Paris', 'London', 'Berlin', NULL, 'B', 'Capital city', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 1 Q2: How many days are in a leap year?', '365', '366', '364', '360', NULL, 'B', 'Calendar', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 1 Q3: Which planet is known as the Red Planet?', 'Earth', 'Venus', 'Mars', 'Jupiter', NULL, 'C', 'Planet', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 1 Q4: Who is the first Prime Minister of India?', 'Jawaharlal Nehru', 'Indira Gandhi', 'Mahatma Gandhi', 'Rajendra Prasad', NULL, 'A', 'History', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 1 Q5: Which language is primarily spoken in Brazil?', 'Spanish', 'Portuguese', 'English', 'French', NULL, 'B', 'Language', 1, 'ACTIVE', NOW(), NOW()),

  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 2 Q1: The largest ocean on Earth is ___.', 'Atlantic', 'Indian', 'Arctic', 'Pacific', NULL, 'D', 'Geography', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 2 Q2: How many continents are there?', '5', '6', '7', '8', NULL, 'C', 'Geography', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 2 Q3: What is H2O commonly known as?', 'Hydrogen', 'Oxygen', 'Water', 'Carbon dioxide', NULL, 'C', 'Chemistry', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 2 Q4: The current year is ___.', '2024', '2025', '2026', '2027', NULL, 'C', 'Current affairs', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @gk2, @topicGk2, 1, 1, 'GK Set 2 Q5: Which planet is nearest to the sun?', 'Earth', 'Venus', 'Mercury', 'Mars', NULL, 'C', 'Astronomy', 1, 'ACTIVE', NOW(), NOW()),

  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 1 Q1: What does CPU stand for?', 'Central Processing Unit', 'Computer Primary Unit', 'Central Program Unit', 'Control Processing Unit', NULL, 'A', 'Computer acronym', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 1 Q2: Which device is used to print documents?', 'Monitor', 'Keyboard', 'Printer', 'Mouse', NULL, 'C', 'Computer hardware', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 1 Q3: Windows, Linux and macOS are examples of ___.', 'Applications', 'Operating Systems', 'Databases', 'Browsers', NULL, 'B', 'Software', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 1 Q4: Which key is used to copy selected text?', 'Alt', 'Ctrl', 'Shift', 'Esc', NULL, 'B', 'Keyboard shortcut', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 1 Q5: Which of these is an input device?', 'Mouse', 'Speaker', 'Printer', 'Monitor', NULL, 'A', 'Input device', 1, 'ACTIVE', NOW(), NOW()),

  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 2 Q1: Which part stores temporary data while a computer runs?', 'Hard disk', 'CPU', 'RAM', 'Motherboard', NULL, 'C', 'Computer memory', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 2 Q2: The main page of a website is called ___.', 'Homepage', 'Dashboard', 'Profile', 'Settings', NULL, 'A', 'Web terminology', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 2 Q3: What is the main function of a router?', 'Store files', 'Route network traffic', 'Print documents', 'Scan barcodes', NULL, 'B', 'Networking', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 2 Q4: Which one is not an operating system?', 'Windows', 'Android', 'Linux', 'Microsoft Word', NULL, 'D', 'Software', 1, 'ACTIVE', NOW(), NOW()),
  (@exam2, @comp2, @topicComp2, 1, 1, 'Comp Set 2 Q5: Which symbol is used to end a sentence?', 'Comma', 'Question mark', 'Exclamation mark', 'Period', NULL, 'D', 'Punctuation', 1, 'ACTIVE', NOW(), NOW());

INSERT INTO quiz_questions (quiz_id, question_id)
SELECT @mathQuiz1, q.id
FROM questions q
WHERE q.question_text LIKE 'Math Set 1 Q%'
ORDER BY q.id;

INSERT INTO quiz_questions (quiz_id, question_id)
SELECT @mathQuiz2, q.id
FROM questions q
WHERE q.question_text LIKE 'Math Set 2 Q%'
ORDER BY q.id;

INSERT INTO quiz_questions (quiz_id, question_id)
SELECT @englishQuiz1, q.id
FROM questions q
WHERE q.question_text LIKE 'English Set 1 Q%'
ORDER BY q.id;

INSERT INTO quiz_questions (quiz_id, question_id)
SELECT @englishQuiz2, q.id
FROM questions q
WHERE q.question_text LIKE 'English Set 2 Q%'
ORDER BY q.id;

INSERT INTO quiz_questions (quiz_id, question_id)
SELECT @gkQuiz1, q.id
FROM questions q
WHERE q.question_text LIKE 'GK Set 1 Q%'
ORDER BY q.id;

INSERT INTO quiz_questions (quiz_id, question_id)
SELECT @gkQuiz2, q.id
FROM questions q
WHERE q.question_text LIKE 'GK Set 2 Q%'
ORDER BY q.id;

INSERT INTO quiz_questions (quiz_id, question_id)
SELECT @compQuiz1, q.id
FROM questions q
WHERE q.question_text LIKE 'Comp Set 1 Q%'
ORDER BY q.id;

INSERT INTO quiz_questions (quiz_id, question_id)
SELECT @compQuiz2, q.id
FROM questions q
WHERE q.question_text LIKE 'Comp Set 2 Q%'
ORDER BY q.id;

COMMIT;
