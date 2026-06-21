package com.quizplatform.api.repository;

import com.quizplatform.api.entity.Subject;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SubjectRepository extends JpaRepository<Subject, Long> {
    List<Subject> findAllByExamId(Long examId);
}
