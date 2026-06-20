package com.quizplatform.api.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "difficulty_levels")
public class DifficultyLevel extends BaseEntity {
    @Column(nullable = false, unique = true, length = 40)
    private String name;

    @Column(nullable = false)
    private int sortOrder;
}
