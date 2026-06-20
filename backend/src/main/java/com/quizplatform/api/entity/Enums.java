package com.quizplatform.api.entity;

public final class Enums {
    private Enums() {
    }

    public enum Status { ACTIVE, INACTIVE }
    public enum UserStatus { ACTIVE, INACTIVE, LOCKED }
    public enum PublishStatus { DRAFT, PUBLISHED, DISABLED }
    public enum QuestionStatus { DRAFT, ACTIVE, INACTIVE }
    public enum AccessType { FREE, PAID }
    public enum AttemptStatus { IN_PROGRESS, SUBMITTED, AUTO_SUBMITTED }
    public enum MaterialType { PDF, VIDEO, DOCUMENT }
    public enum PaymentStatus { CREATED, SUCCESS, FAILED, REFUNDED }
    public enum TargetType { ALL, EXAM, SUBJECT }
}
