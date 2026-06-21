package com.quizplatform.api.repository;

import com.quizplatform.api.entity.Quiz;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuizRepository extends JpaRepository<Quiz, Long> {
    List<Quiz> findAllByExamId(Long examId);

    @EntityGraph(attributePaths = { "exam", "subject", "topic", "questions" })
    Optional<Quiz> findWithDetailsById(Long id);
}
