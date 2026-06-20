package com.quizplatform.api.dto;

import com.quizplatform.api.entity.Enums.AccessType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.util.List;

public final class QuizDtos {
    private QuizDtos() {
    }

    public record QuizRequest(@NotBlank String name, String setName, Integer setNumber,
                              @NotNull Long examId, @NotNull Long subjectId, Long topicId,
                              @Positive int durationMinutes, Integer optionCount, @NotNull BigDecimal totalMarks,
                              @NotNull BigDecimal passingMarks, AccessType accessType, List<Long> questionIds) {
    }

    public record MockTestRequest(@NotBlank String name, @NotNull Long examId, @Positive int durationMinutes,
                                  @NotNull BigDecimal totalMarks, AccessType accessType,
                                  BigDecimal negativeMarking, List<Long> questionIds) {
    }
}
