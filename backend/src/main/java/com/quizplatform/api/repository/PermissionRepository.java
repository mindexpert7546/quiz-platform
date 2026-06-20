package com.quizplatform.api.repository;

import com.quizplatform.api.entity.Permission;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PermissionRepository extends JpaRepository<Permission, Long> {
    Optional<Permission> findByModuleAndAction(String module, String action);
}
