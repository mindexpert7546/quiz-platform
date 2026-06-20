package com.quizplatform.api.controller;

import com.quizplatform.api.dto.BulkUploadDtos.BulkUploadResult;
import com.quizplatform.api.service.BulkUploadService;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/bulk-upload")
public class BulkUploadController {
    private final BulkUploadService bulkUploadService;

    public BulkUploadController(BulkUploadService bulkUploadService) {
        this.bulkUploadService = bulkUploadService;
    }

    @GetMapping("/questions/template")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN','ADMIN','CONTENT_MANAGER')")
    ResponseEntity<Resource> questionTemplate() {
        Resource template = new ClassPathResource("templates/question-upload-template.csv");
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=question-upload-template.csv")
                .contentType(MediaType.parseMediaType("text/csv"))
                .body(template);
    }

    @PostMapping("/questions/validate")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN','ADMIN','CONTENT_MANAGER')")
    BulkUploadResult validateQuestions(@RequestParam("file") MultipartFile file) {
        return bulkUploadService.validateQuestionCsv(file);
    }
}
