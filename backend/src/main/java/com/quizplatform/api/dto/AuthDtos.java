package com.quizplatform.api.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public final class AuthDtos {
    private AuthDtos() {
    }

    public record LoginRequest(@Email String email, @NotBlank String password) {
    }

    public record RegisterRequest(@NotBlank String name, @Email String email, @NotBlank String password,
            String mobileNumber) {
    }

    public record AuthResponse(String token, String tokenType, String name, String email, String role,
            String mobileNumber) {
    }
}
