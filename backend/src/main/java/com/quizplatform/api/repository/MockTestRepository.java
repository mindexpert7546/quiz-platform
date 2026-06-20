package com.quizplatform.api.repository;

import com.quizplatform.api.entity.MockTest;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MockTestRepository extends JpaRepository<MockTest, Long> {
}
