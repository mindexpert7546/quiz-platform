package com.quizplatform.api.entity;

import com.quizplatform.api.entity.Enums.AccessType;
import com.quizplatform.api.entity.Enums.PublishStatus;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Table(name = "mock_tests")
public class MockTest extends BaseEntity {
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "exam_id")
    private Exam exam;

    @Column(nullable = false, length = 180)
    private String name;

    @Column(nullable = false)
    private int durationMinutes;

    @Column(nullable = false)
    private BigDecimal totalMarks;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AccessType accessType = AccessType.FREE;

    @Column(nullable = false)
    private BigDecimal negativeMarking = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PublishStatus status = PublishStatus.DRAFT;

    @ManyToMany
    @JoinTable(name = "mock_questions",
            joinColumns = @JoinColumn(name = "mock_test_id"),
            inverseJoinColumns = @JoinColumn(name = "question_id"))
    private Set<Question> questions = new LinkedHashSet<>();

    public void setExam(Exam exam) { this.exam = exam; }
    public void setName(String name) { this.name = name; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
    public void setTotalMarks(BigDecimal totalMarks) { this.totalMarks = totalMarks; }
    public void setAccessType(AccessType accessType) { this.accessType = accessType == null ? AccessType.FREE : accessType; }
    public void setNegativeMarking(BigDecimal negativeMarking) { this.negativeMarking = negativeMarking; }
    public void setQuestions(Set<Question> questions) { this.questions = questions; }
}
