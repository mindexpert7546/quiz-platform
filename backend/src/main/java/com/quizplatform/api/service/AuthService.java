package com.quizplatform.api.service;

import com.quizplatform.api.dto.AuthDtos.AuthResponse;
import com.quizplatform.api.dto.AuthDtos.LoginRequest;
import com.quizplatform.api.dto.AuthDtos.RegisterRequest;
import com.quizplatform.api.entity.User;
import com.quizplatform.api.exception.ResourceNotFoundException;
import com.quizplatform.api.repository.RoleRepository;
import com.quizplatform.api.repository.UserRepository;
import com.quizplatform.api.security.JwtService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {
    private final UserRepository users;
    private final RoleRepository roles;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(UserRepository users, RoleRepository roles, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.users = users;
        this.roles = roles;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (users.existsByEmail(request.email())) {
            throw new IllegalArgumentException("Email is already registered");
        }
        var role = roles.findByName("STUDENT").orElseThrow(() -> new ResourceNotFoundException("Student role not found"));
        User user = new User();
        user.setName(request.name());
        user.setEmail(request.email());
        user.setMobileNumber(request.mobileNumber());
        user.setPasswordHash(passwordEncoder.encode(request.password()));
        user.setRole(role);
        users.save(user);
        return response(user);
    }

    public AuthResponse login(LoginRequest request) {
        User user = users.findByEmail(request.email()).orElseThrow(() -> new ResourceNotFoundException("Invalid credentials"));
        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new ResourceNotFoundException("Invalid credentials");
        }
        return response(user);
    }

    private AuthResponse response(User user) {
        return new AuthResponse(jwtService.generate(user), "Bearer", user.getName(), user.getEmail(), user.getRole().getName());
    }
}
