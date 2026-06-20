package com.quizplatform.api.controller;

import com.quizplatform.api.dto.MasterDtos.ExamRequest;
import com.quizplatform.api.dto.MasterDtos.SubjectRequest;
import com.quizplatform.api.dto.MasterDtos.TopicRequest;
import com.quizplatform.api.entity.Exam;
import com.quizplatform.api.entity.Subject;
import com.quizplatform.api.entity.Topic;
import com.quizplatform.api.service.MasterService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/masters")
public class MasterController {
    private final MasterService masterService;

    public MasterController(MasterService masterService) {
        this.masterService = masterService;
    }

    @GetMapping("/exams")
    Page<Exam> exams(Pageable pageable) {
        return masterService.exams(pageable);
    }

    @PostMapping("/exams")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN','ADMIN')")
    Exam createExam(@Valid @RequestBody ExamRequest request) {
        return masterService.createExam(request);
    }

    @PostMapping("/subjects")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN','ADMIN')")
    Subject createSubject(@Valid @RequestBody SubjectRequest request) {
        return masterService.createSubject(request);
    }

    @PostMapping("/topics")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN','ADMIN','CONTENT_MANAGER')")
    Topic createTopic(@Valid @RequestBody TopicRequest request) {
        return masterService.createTopic(request);
    }
}
