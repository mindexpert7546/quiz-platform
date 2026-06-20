package com.quizplatform.api.repository;

import com.quizplatform.api.entity.Configuration;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ConfigurationRepository extends JpaRepository<Configuration, Long> {
    Optional<Configuration> findByConfigKey(String configKey);
}
