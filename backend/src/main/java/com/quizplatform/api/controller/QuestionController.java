package com.quizplatform.api.controller;

import com.quizplatform.api.dto.QuestionDtos.QuestionRequest;
import com.quizplatform.api.entity.Question;
import com.quizplatform.api.service.QuestionService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/questions")
public class QuestionController {
    private final QuestionService questionService;

    public QuestionController(QuestionService questionService) {
        this.questionService = questionService;
    }

    @GetMapping
    Page<Question> list(Pageable pageable) {
        return questionService.list(pageable);
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('SUPER_ADMIN','ADMIN','CONTENT_MANAGER')")
    Question create(@Valid @RequestBody QuestionRequest request) {
        return questionService.create(request);
    }

    @PostMapping("/{id}/clone")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN','ADMIN','CONTENT_MANAGER')")
    Question clone(@PathVariable Long id) {
        return questionService.clone(id);
    }
}
