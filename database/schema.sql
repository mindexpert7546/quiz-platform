CREATE DATABASE IF NOT EXISTS exam_prep CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE exam_prep;

CREATE TABLE roles (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(255),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE permissions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  module VARCHAR(80) NOT NULL,
  action VARCHAR(30) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_permission (module, action)
);

CREATE TABLE role_permissions (
  role_id BIGINT NOT NULL,
  permission_id BIGINT NOT NULL,
  PRIMARY KEY (role_id, permission_id),
  CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(id),
  CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(id)
);

CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  role_id BIGINT NOT NULL,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  mobile_number VARCHAR(20),
  password_hash VARCHAR(255) NOT NULL,
  status ENUM('ACTIVE','INACTIVE','LOCKED') NOT NULL DEFAULT 'ACTIVE',
  email_verified BOOLEAN NOT NULL DEFAULT FALSE,
  mobile_verified BOOLEAN NOT NULL DEFAULT FALSE,
  last_login_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id),
  INDEX idx_users_status (status),
  INDEX idx_users_mobile (mobile_number)
);

CREATE TABLE exams (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(160) NOT NULL,
  code VARCHAR(40) NOT NULL UNIQUE,
  description TEXT,
  thumbnail_url VARCHAR(500),
  banner_url VARCHAR(500),
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_exams_status (status)
);

CREATE TABLE subjects (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  exam_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  description TEXT,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_subjects_exam FOREIGN KEY (exam_id) REFERENCES exams(id),
  UNIQUE KEY uk_subject_exam_name (exam_id, name),
  INDEX idx_subjects_status (status)
);

CREATE TABLE topics (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  exam_id BIGINT NOT NULL,
  subject_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  description TEXT,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_topics_exam FOREIGN KEY (exam_id) REFERENCES exams(id),
  CONSTRAINT fk_topics_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
  UNIQUE KEY uk_topic_subject_name (subject_id, name)
);

CREATE TABLE difficulty_levels (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(40) NOT NULL UNIQUE,
  sort_order INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE question_types (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(60) NOT NULL UNIQUE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE questions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  exam_id BIGINT NOT NULL,
  subject_id BIGINT NOT NULL,
  topic_id BIGINT NOT NULL,
  difficulty_level_id BIGINT NOT NULL,
  question_type_id BIGINT NOT NULL,
  question_text TEXT NOT NULL,
  option_a TEXT,
  option_b TEXT,
  option_c TEXT,
  option_d TEXT,
  option_e TEXT,
  correct_answer VARCHAR(100) NOT NULL,
  explanation TEXT,
  marks DECIMAL(6,2) NOT NULL DEFAULT 1,
  status ENUM('DRAFT','ACTIVE','INACTIVE') NOT NULL DEFAULT 'DRAFT',
  created_by BIGINT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_questions_exam FOREIGN KEY (exam_id) REFERENCES exams(id),
  CONSTRAINT fk_questions_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
  CONSTRAINT fk_questions_topic FOREIGN KEY (topic_id) REFERENCES topics(id),
  CONSTRAINT fk_questions_difficulty FOREIGN KEY (difficulty_level_id) REFERENCES difficulty_levels(id),
  CONSTRAINT fk_questions_type FOREIGN KEY (question_type_id) REFERENCES question_types(id),
  CONSTRAINT fk_questions_created_by FOREIGN KEY (created_by) REFERENCES users(id),
  INDEX idx_questions_lookup (exam_id, subject_id, topic_id, difficulty_level_id),
  FULLTEXT KEY ft_questions_text (question_text)
);

CREATE TABLE quizzes (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  exam_id BIGINT NOT NULL,
  subject_id BIGINT NOT NULL,
  topic_id BIGINT,
  name VARCHAR(180) NOT NULL,
  set_name VARCHAR(80),
  set_number INT,
  duration_minutes INT NOT NULL,
  option_count INT NOT NULL DEFAULT 4,
  total_marks DECIMAL(8,2) NOT NULL,
  passing_marks DECIMAL(8,2) NOT NULL,
  access_type ENUM('FREE','PAID') NOT NULL DEFAULT 'FREE',
  status ENUM('DRAFT','PUBLISHED','DISABLED') NOT NULL DEFAULT 'DRAFT',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_quizzes_exam FOREIGN KEY (exam_id) REFERENCES exams(id),
  CONSTRAINT fk_quizzes_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
  CONSTRAINT fk_quizzes_topic FOREIGN KEY (topic_id) REFERENCES topics(id),
  UNIQUE KEY uk_quiz_topic_set (topic_id, set_number),
  INDEX idx_quizzes_status (status),
  INDEX idx_quizzes_exam_subject (exam_id, subject_id),
  INDEX idx_quizzes_topic_set (topic_id, set_number)
);

CREATE TABLE quiz_questions (
  quiz_id BIGINT NOT NULL,
  question_id BIGINT NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  PRIMARY KEY (quiz_id, question_id),
  CONSTRAINT fk_quiz_questions_quiz FOREIGN KEY (quiz_id) REFERENCES quizzes(id),
  CONSTRAINT fk_quiz_questions_question FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE mock_tests (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  exam_id BIGINT NOT NULL,
  name VARCHAR(180) NOT NULL,
  duration_minutes INT NOT NULL,
  total_marks DECIMAL(8,2) NOT NULL,
  access_type ENUM('FREE','PAID') NOT NULL DEFAULT 'FREE',
  negative_marking DECIMAL(5,2) NOT NULL DEFAULT 0,
  status ENUM('DRAFT','PUBLISHED','DISABLED') NOT NULL DEFAULT 'DRAFT',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_mock_tests_exam FOREIGN KEY (exam_id) REFERENCES exams(id),
  INDEX idx_mock_tests_exam_status (exam_id, status)
);

CREATE TABLE mock_questions (
  mock_test_id BIGINT NOT NULL,
  question_id BIGINT NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  PRIMARY KEY (mock_test_id, question_id),
  CONSTRAINT fk_mock_questions_mock FOREIGN KEY (mock_test_id) REFERENCES mock_tests(id),
  CONSTRAINT fk_mock_questions_question FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE subscription_plans (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(80) NOT NULL UNIQUE,
  price DECIMAL(10,2) NOT NULL DEFAULT 0,
  duration_days INT NOT NULL DEFAULT 0,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  features JSON,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE subscriptions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  student_id BIGINT NOT NULL,
  plan_id BIGINT NOT NULL,
  starts_at DATETIME NOT NULL,
  ends_at DATETIME NOT NULL,
  status ENUM('ACTIVE','EXPIRED','CANCELLED') NOT NULL DEFAULT 'ACTIVE',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_subscriptions_student FOREIGN KEY (student_id) REFERENCES users(id),
  CONSTRAINT fk_subscriptions_plan FOREIGN KEY (plan_id) REFERENCES subscription_plans(id),
  INDEX idx_subscriptions_student_status (student_id, status)
);

CREATE TABLE payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  student_id BIGINT NOT NULL,
  subscription_id BIGINT,
  amount DECIMAL(10,2) NOT NULL,
  transaction_id VARCHAR(120) NOT NULL UNIQUE,
  provider VARCHAR(40) NOT NULL DEFAULT 'RAZORPAY',
  status ENUM('CREATED','SUCCESS','FAILED','REFUNDED') NOT NULL,
  paid_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_payments_student FOREIGN KEY (student_id) REFERENCES users(id),
  CONSTRAINT fk_payments_subscription FOREIGN KEY (subscription_id) REFERENCES subscriptions(id),
  INDEX idx_payments_status_date (status, created_at)
);

CREATE TABLE coupons (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE,
  discount_percentage DECIMAL(5,2) NOT NULL,
  expires_at DATETIME NOT NULL,
  usage_count INT NOT NULL DEFAULT 0,
  max_usage_count INT,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE student_attempts (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  student_id BIGINT NOT NULL,
  quiz_id BIGINT,
  mock_test_id BIGINT,
  score DECIMAL(8,2) NOT NULL DEFAULT 0,
  total_marks DECIMAL(8,2) NOT NULL DEFAULT 0,
  correct_count INT NOT NULL DEFAULT 0,
  wrong_count INT NOT NULL DEFAULT 0,
  time_taken_seconds INT NOT NULL DEFAULT 0,
  status ENUM('IN_PROGRESS','SUBMITTED','AUTO_SUBMITTED') NOT NULL DEFAULT 'IN_PROGRESS',
  started_at DATETIME NOT NULL,
  submitted_at DATETIME,
  CONSTRAINT fk_attempts_student FOREIGN KEY (student_id) REFERENCES users(id),
  CONSTRAINT fk_attempts_quiz FOREIGN KEY (quiz_id) REFERENCES quizzes(id),
  CONSTRAINT fk_attempts_mock FOREIGN KEY (mock_test_id) REFERENCES mock_tests(id),
  INDEX idx_attempts_student (student_id),
  INDEX idx_attempts_quiz (quiz_id),
  INDEX idx_attempts_mock (mock_test_id)
);

CREATE TABLE student_answers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  attempt_id BIGINT NOT NULL,
  question_id BIGINT NOT NULL,
  selected_answer VARCHAR(100),
  is_correct BOOLEAN NOT NULL DEFAULT FALSE,
  marks_awarded DECIMAL(6,2) NOT NULL DEFAULT 0,
  marked_for_review BOOLEAN NOT NULL DEFAULT FALSE,
  answered_at DATETIME,
  CONSTRAINT fk_answers_attempt FOREIGN KEY (attempt_id) REFERENCES student_attempts(id),
  CONSTRAINT fk_answers_question FOREIGN KEY (question_id) REFERENCES questions(id),
  UNIQUE KEY uk_answer_attempt_question (attempt_id, question_id)
);

CREATE TABLE study_materials (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  exam_id BIGINT NOT NULL,
  subject_id BIGINT,
  topic_id BIGINT,
  title VARCHAR(180) NOT NULL,
  material_type ENUM('PDF','VIDEO','DOCUMENT') NOT NULL,
  file_url VARCHAR(500),
  video_url VARCHAR(500),
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_materials_exam FOREIGN KEY (exam_id) REFERENCES exams(id),
  CONSTRAINT fk_materials_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
  CONSTRAINT fk_materials_topic FOREIGN KEY (topic_id) REFERENCES topics(id),
  INDEX idx_materials_lookup (exam_id, subject_id, topic_id)
);

CREATE TABLE notifications (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(160) NOT NULL,
  message TEXT NOT NULL,
  target_type ENUM('ALL','EXAM','SUBJECT') NOT NULL DEFAULT 'ALL',
  exam_id BIGINT,
  subject_id BIGINT,
  published_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_notifications_exam FOREIGN KEY (exam_id) REFERENCES exams(id),
  CONSTRAINT fk_notifications_subject FOREIGN KEY (subject_id) REFERENCES subjects(id)
);

CREATE TABLE configurations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  config_key VARCHAR(100) NOT NULL UNIQUE,
  config_value TEXT,
  encrypted BOOLEAN NOT NULL DEFAULT FALSE,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT,
  action VARCHAR(80) NOT NULL,
  entity_name VARCHAR(100) NOT NULL,
  entity_id VARCHAR(80),
  old_value JSON,
  new_value JSON,
  ip_address VARCHAR(64),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_audit_entity (entity_name, entity_id),
  INDEX idx_audit_user_date (user_id, created_at)
);

INSERT INTO roles (name, description) VALUES
  ('SUPER_ADMIN', 'Full system access'),
  ('ADMIN', 'Content and operations administration'),
  ('CONTENT_MANAGER', 'Question and material management'),
  ('STUDENT', 'Exam participant');

INSERT INTO difficulty_levels (name, sort_order) VALUES ('Easy', 1), ('Medium', 2), ('Hard', 3);
INSERT INTO question_types (name) VALUES ('Single Choice'), ('Multiple Choice'), ('True/False');
INSERT INTO subscription_plans (name, price, duration_days, features) VALUES
  ('Free', 0, 0, JSON_ARRAY('Free quizzes')),
  ('Premium', 499, 30, JSON_ARRAY('Paid quizzes', 'Mock tests', 'PDF notes')),
  ('Gold', 1499, 180, JSON_ARRAY('All access', 'Reports', 'Priority content'));
