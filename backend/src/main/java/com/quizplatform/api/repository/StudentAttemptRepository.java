package com.quizplatform.api.repository;

import com.quizplatform.api.entity.StudentAttempt;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentAttemptRepository extends JpaRepository<StudentAttempt, Long> {
}
