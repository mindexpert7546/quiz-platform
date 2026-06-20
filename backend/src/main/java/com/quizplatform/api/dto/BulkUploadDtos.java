package com.quizplatform.api.dto;

import java.util.List;

public final class BulkUploadDtos {
    private BulkUploadDtos() {
    }

    public record BulkUploadResult(int totalRows, int validRows, int errorRows, List<String> errors) {
    }
}
