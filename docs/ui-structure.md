# UI Structure

## Admin Panel

The admin panel is a responsive Angular Material shell with a persistent sidebar and feature routes:

- Dashboard: platform counts, activity feed, chart placeholders.
- Masters: exam, subject, topic, difficulty, question type, plan masters.
- Questions: question bank, clone, preview, bulk upload entry points, and quiz-set mapping.
- Quizzes: topic-wise quiz set management such as Java Set 1, Set 2, Set 3, 4-option or 5-option quiz style, plus full mock test management.
- Students: profile, subscription, attempts, status management.
- Settings: application, SMTP, Razorpay, registration, maintenance settings.

## Student Mobile App

The Flutter app uses Material 3 and route-first screens:

- Login: register/login/forgot password foundation.
- Home: exams, featured quizzes, latest mock tests.
- Exam details: subjects, notes, latest mock entry.
- Quiz details: public quiz metadata, set number, duration, question count, 4-option or 5-option style.
- Quiz: timer, next, previous, mark for review, submit.
- Results: score, percentage, correct/wrong answers, time taken, rank.

## Production UI Next Steps

- Wire forms to backend endpoints for exams, subjects, topics, quiz sets, question mapping, students, payments, notifications, and settings.
- Keep student browsing public and require login/register only when attending a quiz or mock test.
- Add auth guards and refresh-token handling.
- Replace sample rows with paginated API tables.
- Add upload components for thumbnails, banners, PDFs, and Excel.
- Add chart components for revenue, attempts, and performance reports.
