package com.quizplatform.api.repository;

import com.quizplatform.api.entity.StudyMaterial;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudyMaterialRepository extends JpaRepository<StudyMaterial, Long> {
}
