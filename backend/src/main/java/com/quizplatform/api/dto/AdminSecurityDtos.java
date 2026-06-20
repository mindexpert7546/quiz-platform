package com.quizplatform.api.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import java.util.List;

public final class AdminSecurityDtos {
    private AdminSecurityDtos() {
    }

    public record PromoteUserRequest(@NotBlank String roleName) {
    }

    public record PermissionRequest(@NotBlank String module, @NotEmpty List<String> actions) {
    }

    public record RolePermissionRequest(@NotEmpty List<PermissionRequest> permissions) {
    }
}
