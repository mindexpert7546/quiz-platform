package com.quizplatform.api.service;

import com.quizplatform.api.dto.QuizDtos.MockTestRequest;
import com.quizplatform.api.dto.QuizDtos.QuizRequest;
import com.quizplatform.api.entity.MockTest;
import com.quizplatform.api.entity.Quiz;
import com.quizplatform.api.exception.ResourceNotFoundException;
import com.quizplatform.api.repository.ExamRepository;
import com.quizplatform.api.repository.MockTestRepository;
import com.quizplatform.api.repository.QuestionRepository;
import com.quizplatform.api.repository.QuizRepository;
import com.quizplatform.api.repository.SubjectRepository;
import com.quizplatform.api.repository.TopicRepository;
import java.math.BigDecimal;
import java.util.LinkedHashSet;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class QuizService {
    private final QuizRepository quizzes;
    private final MockTestRepository mockTests;
    private final ExamRepository exams;
    private final SubjectRepository subjects;
    private final TopicRepository topics;
    private final QuestionRepository questions;

    public QuizService(QuizRepository quizzes, MockTestRepository mockTests, ExamRepository exams,
                       SubjectRepository subjects, TopicRepository topics, QuestionRepository questions) {
        this.quizzes = quizzes;
        this.mockTests = mockTests;
        this.exams = exams;
        this.subjects = subjects;
        this.topics = topics;
        this.questions = questions;
    }

    @Transactional
    public Quiz createQuiz(QuizRequest request) {
        Quiz quiz = new Quiz();
        quiz.setName(request.name());
        quiz.setSetName(request.setName());
        quiz.setSetNumber(request.setNumber());
        quiz.setExam(exams.findById(request.examId()).orElseThrow(() -> new ResourceNotFoundException("Exam not found")));
        quiz.setSubject(subjects.findById(request.subjectId()).orElseThrow(() -> new ResourceNotFoundException("Subject not found")));
        if (request.topicId() != null) {
            quiz.setTopic(topics.findById(request.topicId()).orElseThrow(() -> new ResourceNotFoundException("Topic not found")));
        }
        quiz.setDurationMinutes(request.durationMinutes());
        quiz.setOptionCount(request.optionCount());
        quiz.setTotalMarks(request.totalMarks());
        quiz.setPassingMarks(request.passingMarks());
        quiz.setAccessType(request.accessType());
        quiz.setQuestions(new LinkedHashSet<>(questions.findAllById(request.questionIds())));
        return quizzes.save(quiz);
    }

    @Transactional
    public MockTest createMock(MockTestRequest request) {
        MockTest mock = new MockTest();
        mock.setName(request.name());
        mock.setExam(exams.findById(request.examId()).orElseThrow(() -> new ResourceNotFoundException("Exam not found")));
        mock.setDurationMinutes(request.durationMinutes());
        mock.setTotalMarks(request.totalMarks());
        mock.setAccessType(request.accessType());
        mock.setNegativeMarking(request.negativeMarking() == null ? BigDecimal.ZERO : request.negativeMarking());
        mock.setQuestions(new LinkedHashSet<>(questions.findAllById(request.questionIds())));
        return mockTests.save(mock);
    }
}
