package com.quizplatform.api.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "question_types")
public class QuestionType extends BaseEntity {
    @Column(nullable = false, unique = true, length = 60)
    private String name;
}
