package com.quizplatform.api.config;

import com.quizplatform.api.entity.Enums.UserStatus;
import com.quizplatform.api.entity.Permission;
import com.quizplatform.api.entity.Role;
import com.quizplatform.api.entity.User;
import com.quizplatform.api.repository.PermissionRepository;
import com.quizplatform.api.repository.RoleRepository;
import com.quizplatform.api.repository.UserRepository;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableConfigurationProperties(BootstrapProperties.class)
public class DataBootstrapConfig {
    private static final List<String> MODULES = List.of(
            "DASHBOARD", "MASTERS", "QUESTIONS", "QUIZZES", "MOCK_TESTS", "STUDENTS",
            "RESULTS", "SUBSCRIPTIONS", "PAYMENTS", "CONTENT", "NOTIFICATIONS",
            "TOOLS", "SECURITY", "SETTINGS", "AUDIT_LOGS");
    private static final List<String> ACTIONS = List.of("VIEW", "CREATE", "EDIT", "DELETE", "PUBLISH");

    @Bean
    CommandLineRunner bootstrapData(RoleRepository roles, PermissionRepository permissions, UserRepository users,
                                    PasswordEncoder passwordEncoder, BootstrapProperties bootstrap) {
        return args -> {
            Set<Permission> allPermissions = MODULES.stream()
                    .flatMap(module -> ACTIONS.stream().map(action -> permission(permissions, module, action)))
                    .collect(Collectors.toSet());

            Role superAdmin = role(roles, "SUPER_ADMIN", "Full system access");
            superAdmin.setPermissions(allPermissions);
            roles.save(superAdmin);

            role(roles, "ADMIN", "Access controlled by Super Admin");
            role(roles, "CONTENT_MANAGER", "Question and material management");
            role(roles, "STUDENT", "Exam participant");

            if (bootstrap.isEnabled() && !users.existsByEmail(bootstrap.getEmail())) {
                User user = new User();
                user.setName(bootstrap.getName());
                user.setEmail(bootstrap.getEmail());
                user.setPasswordHash(passwordEncoder.encode(bootstrap.getPassword()));
                user.setRole(superAdmin);
                user.setStatus(UserStatus.ACTIVE);
                users.save(user);
            }
        };
    }

    private Permission permission(PermissionRepository permissions, String module, String action) {
        return permissions.findByModuleAndAction(module, action).orElseGet(() -> {
            Permission permission = new Permission();
            permission.setModule(module);
            permission.setAction(action);
            return permissions.save(permission);
        });
    }

    private Role role(RoleRepository roles, String name, String description) {
        return roles.findByName(name).orElseGet(() -> {
            Role role = new Role();
            role.setName(name);
            role.setDescription(description);
            return roles.save(role);
        });
    }
}
