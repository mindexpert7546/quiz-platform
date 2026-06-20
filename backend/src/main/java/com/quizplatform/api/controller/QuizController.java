package com.quizplatform.api.controller;

import com.quizplatform.api.dto.QuizDtos.MockTestRequest;
import com.quizplatform.api.dto.QuizDtos.QuizRequest;
import com.quizplatform.api.entity.MockTest;
import com.quizplatform.api.entity.Quiz;
import com.quizplatform.api.service.QuizService;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping
public class QuizController {
    private final QuizService quizService;

    public QuizController(QuizService quizService) {
        this.quizService = quizService;
    }

    @PostMapping("/quizzes")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN','ADMIN','CONTENT_MANAGER')")
    Quiz createQuiz(@Valid @RequestBody QuizRequest request) {
        return quizService.createQuiz(request);
    }

    @PostMapping("/mock-tests")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN','ADMIN','CONTENT_MANAGER')")
    MockTest createMock(@Valid @RequestBody MockTestRequest request) {
        return quizService.createMock(request);
    }
}
