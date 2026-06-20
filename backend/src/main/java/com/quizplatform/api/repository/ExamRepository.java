package com.quizplatform.api.repository;

import com.quizplatform.api.entity.Exam;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExamRepository extends JpaRepository<Exam, Long> {
    boolean existsByCode(String code);
}
