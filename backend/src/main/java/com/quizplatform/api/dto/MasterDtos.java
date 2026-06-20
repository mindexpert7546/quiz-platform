package com.quizplatform.api.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public final class MasterDtos {
    private MasterDtos() {
    }

    public record ExamRequest(@NotBlank String name, @NotBlank String code, String description, String thumbnailUrl, String bannerUrl) {
    }

    public record SubjectRequest(@NotNull Long examId, @NotBlank String name, String description) {
    }

    public record TopicRequest(@NotNull Long examId, @NotNull Long subjectId, @NotBlank String name, String description) {
    }
}
