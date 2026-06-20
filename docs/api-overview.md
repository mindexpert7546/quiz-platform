# REST API Overview

Base path: `/api`

## Authentication

- `POST /auth/register`
- `POST /auth/login`

## Public Browsing

These endpoints are open so students can view exam and quiz details before login:

- `GET /public/exams`
- `GET /public/quizzes`

Login/register is required only when the student starts or attends a quiz/mock test.

## Dashboard

- `GET /dashboard/summary`

## Master Data

- `GET /masters/exams`
- `POST /masters/exams`
- `POST /masters/subjects`
- `POST /masters/topics`

## Question Bank

- `GET /questions`
- `POST /questions`
- `POST /questions/{id}/clone`

## Quiz and Mock Tests

- `POST /quizzes`
- `POST /mock-tests`

Topic quizzes support `setName` and `setNumber`, so one topic can have multiple sets:

```json
{
  "name": "Java Basics",
  "setName": "Set 1",
  "setNumber": 1,
  "examId": 1,
  "subjectId": 1,
  "topicId": 1,
  "durationMinutes": 20,
  "optionCount": 4,
  "totalMarks": 25,
  "passingMarks": 10,
  "accessType": "FREE",
  "questionIds": [1, 2, 3]
}
```

Use `"optionCount": 5` for exams that require five options. Question payloads support `optionE`; leave `optionE` empty or null for four-option quizzes.

## Bulk Upload

- `GET /bulk-upload/questions/template`
- `POST /bulk-upload/questions/validate`

The question upload template includes `quiz_name`, `quiz_set`, `set_number`, `option_count`, `question_order`, and `option_e` columns. This lets admins upload questions directly for topic-wise sets like Java Set 1, Set 2, and Set 3, with either 4-option or 5-option quiz style.

## Admin Security

The first Super Admin is created automatically when the backend starts if no matching user exists.

Default local credentials:

```text
email: admin@example.com
password: Admin@12345
```

Super Admin APIs:

- `GET /admin/security/users`
- `GET /admin/security/roles`
- `GET /admin/security/permissions`
- `PATCH /admin/security/users/{userId}/promote`
- `PUT /admin/security/roles/{roleName}/permissions`

Promote user:

```json
{
  "roleName": "ADMIN"
}
```

Grant module access:

```json
{
  "permissions": [
    { "module": "QUESTIONS", "actions": ["VIEW", "CREATE", "EDIT", "DELETE"] },
    { "module": "QUIZZES", "actions": ["VIEW", "CREATE", "EDIT", "PUBLISH"] }
  ]
}
```

## Planned API Groups

The schema and UI are ready for these modules:

- `students` - activation, deactivation, profile, reset password.
- `attempts` - start quiz, save answer, mark for review, submit, auto-submit.
- `results` - quiz results, mock results, leaderboard.
- `reports` - exam-wise, subject-wise, topic-wise, student-wise exports.
- `payments` - Razorpay orders, webhooks, payment history.
- `notifications` - push notifications and announcements.
- `settings` - SMTP, SMS, Firebase, Razorpay, storage, maintenance mode.

Swagger UI is available at `/api/swagger-ui.html` when the backend is running.
