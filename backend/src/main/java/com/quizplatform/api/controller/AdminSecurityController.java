package com.quizplatform.api.controller;

import com.quizplatform.api.dto.AdminSecurityDtos.PromoteUserRequest;
import com.quizplatform.api.dto.AdminSecurityDtos.RolePermissionRequest;
import com.quizplatform.api.entity.Role;
import com.quizplatform.api.entity.User;
import com.quizplatform.api.repository.PermissionRepository;
import com.quizplatform.api.repository.RoleRepository;
import com.quizplatform.api.repository.UserRepository;
import com.quizplatform.api.service.AdminSecurityService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/admin/security")
@PreAuthorize("hasRole('SUPER_ADMIN')")
public class AdminSecurityController {
    private final AdminSecurityService adminSecurityService;
    private final UserRepository users;
    private final RoleRepository roles;
    private final PermissionRepository permissions;

    public AdminSecurityController(AdminSecurityService adminSecurityService, UserRepository users,
                                   RoleRepository roles, PermissionRepository permissions) {
        this.adminSecurityService = adminSecurityService;
        this.users = users;
        this.roles = roles;
        this.permissions = permissions;
    }

    @GetMapping("/users")
    List<User> users() {
        return users.findAll();
    }

    @GetMapping("/roles")
    List<Role> roles() {
        return roles.findAll();
    }

    @GetMapping("/permissions")
    Object permissions() {
        return permissions.findAll();
    }

    @PatchMapping("/users/{userId}/promote")
    User promote(@PathVariable Long userId, @Valid @RequestBody PromoteUserRequest request) {
        return adminSecurityService.promoteUser(userId, request.roleName());
    }

    @PutMapping("/roles/{roleName}/permissions")
    Role updateRolePermissions(@PathVariable String roleName, @Valid @RequestBody RolePermissionRequest request) {
        return adminSecurityService.updateRolePermissions(roleName, request);
    }
}
