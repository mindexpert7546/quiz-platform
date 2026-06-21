package com.quizplatform.api.dto;

import java.math.BigDecimal;
import java.util.List;

public final class PublicDtos {
    private PublicDtos() {
    }

    public record ExamSummaryResponse(Long id, String name, String description) {
    }

    public record QuizSummaryResponse(Long id, String name, String setName, int durationMinutes, int optionCount,
            Long examId, String examName, String subjectName, String topicName) {
    }

    public record SubjectSummaryResponse(Long id, String name, String description, int quizCount) {
    }

    public record ExamDetailResponse(Long id, String name, String code, String description, String thumbnailUrl,
            String bannerUrl, List<QuizSummaryResponse> quizzes) {
    }

    public record QuizDetailResponse(Long id, String name, String setName, Integer setNumber,
            int durationMinutes, int optionCount, String accessType,
            BigDecimal totalMarks, BigDecimal passingMarks, Long examId,
            String examName, String subjectName, String topicName, int questionCount) {
    }

    public record QuestionResponse(Long id, String questionText, String optionA, String optionB,
            String optionC, String optionD, String optionE) {
    }
}
