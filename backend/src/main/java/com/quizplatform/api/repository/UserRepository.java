package com.quizplatform.api.repository;

import com.quizplatform.api.entity.User;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    @EntityGraph(attributePaths = {"role", "role.permissions"})
    Optional<User> findByEmail(String email);

    @Override
    @EntityGraph(attributePaths = {"role", "role.permissions"})
    List<User> findAll();

    boolean existsByEmail(String email);
}
