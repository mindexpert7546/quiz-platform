# Folder Structure

```text
Quiz 2.0/
  backend/
    src/main/java/com/quizplatform/api/
      config/          OpenAPI and application configuration
      controller/      REST API entry points
      dto/             Request and response contracts
      entity/          JPA entities and enums
      exception/       Global exception handling
      repository/      Spring Data JPA repositories
      security/        JWT and Spring Security
      service/         Business use cases
    src/main/resources/application.yml
    pom.xml
  admin-panel/
    src/app/core/      API service and auth interceptor
    src/app/features/  Dashboard, masters, questions, quizzes, students, settings
    src/styles/        Global admin styles
  mobile-app/
    lib/core/          Dio client and shared providers
    lib/features/      Auth, home, exam, quiz, results
  database/
    schema.sql         MySQL schema, indexes, FKs, seed master data
  docs/
```

## Backend Package Intent

- Controllers stay thin and expose REST endpoints.
- Services own validation and business workflows.
- Repositories provide persistence only.
- DTOs keep API payloads separate from persistence entities.
- Security is stateless JWT with role-based authorization.

## SaaS Extension Points

- Add `tenant_id` to content tables for multi-tenant deployments.
- Move media files to S3 by implementing storage behind configuration.
- Add `created_by` and `updated_by` auditing on admin-owned resources.
- Add report materialization tables if analytics load grows.
