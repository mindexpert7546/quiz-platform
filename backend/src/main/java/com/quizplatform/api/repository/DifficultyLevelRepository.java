package com.quizplatform.api.repository;

import com.quizplatform.api.entity.DifficultyLevel;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DifficultyLevelRepository extends JpaRepository<DifficultyLevel, Long> {
}
