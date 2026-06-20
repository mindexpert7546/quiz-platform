# Exam Preparation Platform

Production-oriented monorepo scaffold for a multi-exam preparation SaaS platform.

## Modules

- `backend` - Spring Boot 3 REST API with JWT security, JPA entities, Swagger/OpenAPI, validation, audit fields, and MySQL configuration.
- `admin-panel` - Angular 20+ admin shell design with Material-oriented routing, services, and feature screens.
- `mobile-app` - Flutter Material 3 student app shell using Riverpod, Go Router, and Dio.
- `database` - MySQL schema with foreign keys, indexes, seed master data, and SaaS-ready tables.
- `docs` - API, folder structure, and UI structure notes.

## Quick Start

Backend:

```powershell
cd backend
mvn spring-boot:run
```

Admin:

```powershell
cd admin-panel
npm install
npm start
```

Mobile:

```powershell
cd mobile-app
flutter pub get
flutter run
```

## Default API

- Base URL: `http://localhost:8080/api`
- Swagger UI: `http://localhost:8080/swagger-ui.html`
- MySQL database: `exam_prep`
- Default Super Admin: `admin@example.com` / `Admin@12345`

Create the database first:

```sql
CREATE DATABASE exam_prep CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Then run `database/schema.sql` or let Hibernate validate after importing the schema.
