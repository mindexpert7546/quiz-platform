package com.quizplatform.api.controller;

import com.quizplatform.api.repository.ExamRepository;
import com.quizplatform.api.repository.MockTestRepository;
import com.quizplatform.api.repository.QuestionRepository;
import com.quizplatform.api.repository.QuizRepository;
import com.quizplatform.api.repository.SubjectRepository;
import com.quizplatform.api.repository.TopicRepository;
import com.quizplatform.api.repository.UserRepository;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/dashboard")
public class DashboardController {
    private final UserRepository users;
    private final ExamRepository exams;
    private final SubjectRepository subjects;
    private final TopicRepository topics;
    private final QuestionRepository questions;
    private final QuizRepository quizzes;
    private final MockTestRepository mockTests;

    public DashboardController(UserRepository users, ExamRepository exams, SubjectRepository subjects,
                               TopicRepository topics, QuestionRepository questions,
                               QuizRepository quizzes, MockTestRepository mockTests) {
        this.users = users;
        this.exams = exams;
        this.subjects = subjects;
        this.topics = topics;
        this.questions = questions;
        this.quizzes = quizzes;
        this.mockTests = mockTests;
    }

    @GetMapping("/summary")
    Map<String, Long> summary() {
        return Map.of(
                "totalStudents", users.count(),
                "totalExams", exams.count(),
                "totalSubjects", subjects.count(),
                "totalTopics", topics.count(),
                "totalQuestions", questions.count(),
                "totalQuizzes", quizzes.count(),
                "totalMockTests", mockTests.count(),
                "totalRevenue", 0L);
    }
}
