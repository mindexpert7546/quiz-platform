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
@Table(name = "quizzes")
public class Quiz extends BaseEntity {
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "exam_id")
    private Exam exam;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "subject_id")
    private Subject subject;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id")
    private Topic topic;

    @Column(nullable = false, length = 180)
    private String name;

    @Column(length = 80)
    private String setName;

    private Integer setNumber;

    @Column(nullable = false)
    private int durationMinutes;

    @Column(nullable = false)
    private int optionCount = 4;

    @Column(nullable = false)
    private BigDecimal totalMarks;

    @Column(nullable = false)
    private BigDecimal passingMarks;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AccessType accessType = AccessType.FREE;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PublishStatus status = PublishStatus.DRAFT;

    @ManyToMany
    @JoinTable(name = "quiz_questions",
            joinColumns = @JoinColumn(name = "quiz_id"),
            inverseJoinColumns = @JoinColumn(name = "question_id"))
    private Set<Question> questions = new LinkedHashSet<>();

    public void setExam(Exam exam) { this.exam = exam; }
    public void setSubject(Subject subject) { this.subject = subject; }
    public void setTopic(Topic topic) { this.topic = topic; }
    public void setName(String name) { this.name = name; }
    public void setSetName(String setName) { this.setName = setName; }
    public void setSetNumber(Integer setNumber) { this.setNumber = setNumber; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
    public void setOptionCount(Integer optionCount) { this.optionCount = optionCount == null ? 4 : optionCount; }
    public void setTotalMarks(BigDecimal totalMarks) { this.totalMarks = totalMarks; }
    public void setPassingMarks(BigDecimal passingMarks) { this.passingMarks = passingMarks; }
    public void setAccessType(AccessType accessType) { this.accessType = accessType == null ? AccessType.FREE : accessType; }
    public void setQuestions(Set<Question> questions) { this.questions = questions; }
}
