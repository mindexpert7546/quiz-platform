package com.quizplatform.api.controller;

import com.quizplatform.api.entity.Exam;
import com.quizplatform.api.entity.Quiz;
import com.quizplatform.api.repository.ExamRepository;
import com.quizplatform.api.repository.QuizRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/public")
public class PublicCatalogController {
    private final ExamRepository exams;
    private final QuizRepository quizzes;

    public PublicCatalogController(ExamRepository exams, QuizRepository quizzes) {
        this.exams = exams;
        this.quizzes = quizzes;
    }

    @GetMapping("/exams")
    Page<Exam> exams(Pageable pageable) {
        return exams.findAll(pageable);
    }

    @GetMapping("/quizzes")
    Page<Quiz> quizzes(Pageable pageable) {
        return quizzes.findAll(pageable);
    }
}
