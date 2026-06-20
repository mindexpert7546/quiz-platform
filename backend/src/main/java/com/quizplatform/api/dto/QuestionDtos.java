package com.quizplatform.api.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;

public final class QuestionDtos {
    private QuestionDtos() {
    }

    public record QuestionRequest(
            @NotNull Long examId,
            @NotNull Long subjectId,
            @NotNull Long topicId,
            @NotNull Long difficultyLevelId,
            @NotNull Long questionTypeId,
            @NotBlank String questionText,
            String optionA,
            String optionB,
            String optionC,
            String optionD,
            String optionE,
            @NotBlank String correctAnswer,
            String explanation,
            @Positive BigDecimal marks) {
    }
}
