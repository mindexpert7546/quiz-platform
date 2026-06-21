# Run App Step By Step

This project has three apps:

- Backend API: Spring Boot
- Admin Panel: Angular
- Student Mobile App: Flutter

## 1. Install Required Tools

Install these first:

- Java 21 or newer
- Maven
- MySQL Server
- Node.js and npm
- Angular CLI
- Flutter SDK

Check tools:

```powershell
java -version
mvn -version
node -v
npm -v
ng version
flutter --version
mysql --version
```

If `ng` is missing:

```powershell
npm install -g @angular/cli
```

## 2. Create MySQL Database

Open MySQL and create only the database:

```sql
CREATE DATABASE exam_prep CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Do not import `database/schema.sql` for the Hibernate development setup. Hibernate will create the tables when the backend starts.

## 3. Configure Backend Database Login

Open:

```text
backend/src/main/resources/application.yml
```

Update these values if your MySQL username or password is different:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/exam_prep?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
    username: root
    password: root
```

Use Hibernate auto table creation for local development:

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: update
```

With `ddl-auto: update`, Spring Boot creates missing tables and updates the schema from the JPA entities when the backend starts.

## 4. Run Backend API

Go to backend folder:

```powershell
cd backend
```

Run tests:

```powershell
mvn test
```

Start backend:

```powershell
mvn spring-boot:run
```

Backend runs at:

```text
http://localhost:8080/api
```

Swagger API docs:

```text
http://localhost:8080/api/swagger-ui.html
```

Keep this terminal running.

Default Super Admin is created automatically on first backend run:

```text
Email: admin@example.com
Password: Admin@12345
```

You can change this in:

```text
backend/src/main/resources/application.yml
```

## 5. Run Admin Panel

Open a new terminal from the project root.

Go to admin folder:

```powershell
cd admin-panel
```

Install packages:

```powershell
npm install
```

Start Angular app:

```powershell
npm start
```

Admin panel runs at:

```text
http://localhost:4200
```

When you open the admin panel, it shows the login page first. Dashboard and all admin modules are blocked until login.

First login:

```text
Email: admin@example.com
Password: Admin@12345
```

The admin panel is the control center for:

- Dashboard and analytics
- Exam, subject, topic, difficulty, and question type masters
- Topic-wise quiz sets, for example Java Set 1, Set 2, Set 3
- Question bank and bulk upload template
- Full mock tests
- Students and attempts
- Results and leaderboard
- Subscription plans, payments, and coupons
- Study materials and PDF notes
- Push notifications and announcements
- SMTP, SMS, Firebase, Razorpay, and storage settings
- Admin users, roles, permissions, and audit logs

Super Admin can:

- Add multiple admins
- Promote a student/user to Content Manager, Admin, or Super Admin
- Decide which modules each admin role can access
- Grant actions per module: View, Create, Edit, Delete, Publish

Example: one admin can access only Questions and Quizzes, while another admin can access Payments, Students, and Reports.

Keep this terminal running.

## 6. Run Flutter Mobile App

Open a new terminal from the project root.

Go to mobile folder:

```powershell
cd mobile-app
```

Install Flutter packages:

```powershell
flutter pub get
```

Check connected devices:

```powershell
flutter devices
```

Run app:

```powershell
flutter clean
flutter pub get
flutter run
```

```powershell
flutter run
```

For Android Emulator, the app uses this backend URL:

```text
http://10.0.2.2:8080/api
```

For a real phone, update `mobile-app/lib/core/api_client.dart` and replace `10.0.2.2` with your computer IP address.

Example:

```dart
baseUrl: 'http://192.168.1.10:8080/api'
```

## 7. Recommended Run Order

Run in this order:

1. Start MySQL.
2. Create the `exam_prep` database.
3. Start backend with `mvn spring-boot:run`.
4. Hibernate creates the tables automatically.
5. Open Swagger and confirm backend works.
6. Start admin panel with `npm start`.
7. Start mobile app with `flutter run`.

## 8. Useful API Endpoints

Auth:

```text
POST http://localhost:8080/api/auth/register
POST http://localhost:8080/api/auth/login
```

Dashboard:

```text
GET http://localhost:8080/api/dashboard/summary
```

Public browsing, no login required:

```text
GET http://localhost:8080/api/public/exams
GET http://localhost:8080/api/public/quizzes
```

Master data:

```text
GET  http://localhost:8080/api/masters/exams
POST http://localhost:8080/api/masters/exams
POST http://localhost:8080/api/masters/subjects
POST http://localhost:8080/api/masters/topics
```

Question bank:

```text
GET  http://localhost:8080/api/questions
POST http://localhost:8080/api/questions
POST http://localhost:8080/api/questions/{id}/clone
```

Bulk upload:

```text
GET  http://localhost:8080/api/bulk-upload/questions/template
POST http://localhost:8080/api/bulk-upload/questions/validate
```

Admin security:

```text
GET   http://localhost:8080/api/admin/security/users
GET   http://localhost:8080/api/admin/security/roles
GET   http://localhost:8080/api/admin/security/permissions
PATCH http://localhost:8080/api/admin/security/users/{userId}/promote
PUT   http://localhost:8080/api/admin/security/roles/{roleName}/permissions
```

The bulk upload template supports topic quiz sets and both 4-option and 5-option quiz styles:

```text
exam_code, subject_name, topic_name, quiz_name, quiz_set, set_number, option_count, question_order
```

Example:

```text
BPSC-TRE-4, Computer Science, Java, Java Basics, Set 1, 1, 4, 1
BPSC-TRE-4, Computer Science, Java, Java OOP Practice, Set 2, 2, 5, 1
BPSC-TRE-4, Computer Science, Java, Java Collections, Set 3, 3, 4, 1
```

For 5-option quizzes, fill `option_e`. For 4-option quizzes, keep `option_e` empty.

## 9. Common Problems

### MySQL Login Error

Update username and password in:

```text
backend/src/main/resources/application.yml
```

### Port 8080 Already Used

Change backend port in `application.yml`:

```yaml
server:
  port: 8081
```

Then update admin and mobile API URLs.

### Angular Command Not Found

Install Angular CLI:

```powershell
npm install -g @angular/cli
```

### Flutter Command Not Found

Install Flutter SDK and add Flutter `bin` folder to PATH.

Then restart terminal and run:

```powershell
flutter doctor
```

### Backend Build With Java 26 Warning

Warnings from Maven on Java 26 can appear, but the backend builds successfully. For production, Java 21 LTS is recommended.

### Want To Use SQL Schema Instead

For production-style database setup, change:

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: validate
```

Then import the schema manually:

```powershell
mysql -u root -p exam_prep < database\schema.sql
```

## 10. Stop Apps

In each running terminal, press:

```text
Ctrl + C
```
