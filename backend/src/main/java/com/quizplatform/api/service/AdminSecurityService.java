package com.quizplatform.api.service;

import com.quizplatform.api.dto.AdminSecurityDtos.RolePermissionRequest;
import com.quizplatform.api.entity.Permission;
import com.quizplatform.api.entity.Role;
import com.quizplatform.api.entity.User;
import com.quizplatform.api.exception.ResourceNotFoundException;
import com.quizplatform.api.repository.PermissionRepository;
import com.quizplatform.api.repository.RoleRepository;
import com.quizplatform.api.repository.UserRepository;
import java.util.HashSet;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminSecurityService {
    private final UserRepository users;
    private final RoleRepository roles;
    private final PermissionRepository permissions;

    public AdminSecurityService(UserRepository users, RoleRepository roles, PermissionRepository permissions) {
        this.users = users;
        this.roles = roles;
        this.permissions = permissions;
    }

    @Transactional
    public User promoteUser(Long userId, String roleName) {
        User user = users.findById(userId).orElseThrow(() -> new ResourceNotFoundException("User not found"));
        Role role = roles.findByName(roleName).orElseThrow(() -> new ResourceNotFoundException("Role not found"));
        user.setRole(role);
        return users.save(user);
    }

    @Transactional
    public Role updateRolePermissions(String roleName, RolePermissionRequest request) {
        Role role = roles.findByName(roleName).orElseThrow(() -> new ResourceNotFoundException("Role not found"));
        if ("SUPER_ADMIN".equals(role.getName())) {
            throw new IllegalArgumentException("SUPER_ADMIN permissions cannot be reduced");
        }
        var selected = new HashSet<Permission>();
        request.permissions().forEach(group -> group.actions().forEach(action -> {
            Permission permission = permissions.findByModuleAndAction(group.module(), action).orElseGet(() -> {
                Permission created = new Permission();
                created.setModule(group.module());
                created.setAction(action);
                return permissions.save(created);
            });
            selected.add(permission);
        }));
        role.setPermissions(selected);
        return roles.save(role);
    }
}
