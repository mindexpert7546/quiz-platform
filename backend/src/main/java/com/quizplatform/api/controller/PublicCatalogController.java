package com.quizplatform.api.controller;

import com.quizplatform.api.dto.PublicDtos.ExamDetailResponse;
import com.quizplatform.api.dto.PublicDtos.ExamSummaryResponse;
import com.quizplatform.api.dto.PublicDtos.QuestionResponse;
import com.quizplatform.api.dto.PublicDtos.QuizDetailResponse;
import com.quizplatform.api.dto.PublicDtos.QuizSummaryResponse;
import com.quizplatform.api.entity.Exam;
import com.quizplatform.api.entity.Quiz;
import com.quizplatform.api.repository.ExamRepository;
import com.quizplatform.api.repository.QuizRepository;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/public")
@Transactional(readOnly = true)
public class PublicCatalogController {
    private final ExamRepository exams;
    private final QuizRepository quizzes;

    public PublicCatalogController(ExamRepository exams, QuizRepository quizzes) {
        this.exams = exams;
        this.quizzes = quizzes;
    }

    @GetMapping("/exams")
    Page<ExamSummaryResponse> exams(Pageable pageable) {
        return exams.findAll(pageable).map(this::toExamSummary);
    }

    @GetMapping("/quizzes")
    Page<QuizSummaryResponse> quizzes(Pageable pageable) {
        return quizzes.findAll(pageable).map(this::toQuizSummary);
    }

    @GetMapping("/exams/{id}")
    ExamDetailResponse exam(@PathVariable Long id) {
        Exam exam = exams.findById(id).orElseThrow(() -> new IllegalArgumentException("Exam not found"));
        List<QuizSummaryResponse> quizSummaries = quizzes.findAllByExamId(id).stream().map(this::toQuizSummary)
                .toList();
        return new ExamDetailResponse(
                exam.getId(),
                exam.getName(),
                exam.getCode(),
                exam.getDescription(),
                exam.getThumbnailUrl(),
                exam.getBannerUrl(),
                quizSummaries);
    }

    @GetMapping("/quizzes/{id}")
    QuizDetailResponse quiz(@PathVariable Long id) {
        Quiz quiz = quizzes.findWithDetailsById(id).orElseThrow(() -> new IllegalArgumentException("Quiz not found"));
        return new QuizDetailResponse(
                quiz.getId(),
                quiz.getName(),
                quiz.getSetName(),
                quiz.getSetNumber(),
                quiz.getDurationMinutes(),
                quiz.getOptionCount(),
                quiz.getAccessType().name(),
                quiz.getTotalMarks(),
                quiz.getPassingMarks(),
                quiz.getExam().getId(),
                quiz.getExam().getName(),
                quiz.getSubject().getName(),
                quiz.getTopic() != null ? quiz.getTopic().getName() : null,
                quiz.getQuestions().size());
    }

    @GetMapping("/quizzes/{id}/questions")
    @Transactional
    List<QuestionResponse> quizQuestions(@PathVariable Long id) {
        Quiz quiz = quizzes.findWithDetailsById(id).orElseThrow(() -> new IllegalArgumentException("Quiz not found"));
        return quiz.getQuestions().stream().map(question -> new QuestionResponse(
                question.getId(),
                question.getQuestionText(),
                question.getOptionA(),
                question.getOptionB(),
                question.getOptionC(),
                question.getOptionD(),
                question.getOptionE())).toList();
    }

    private ExamSummaryResponse toExamSummary(Exam exam) {
        return new ExamSummaryResponse(
                exam.getId(),
                exam.getName(),
                exam.getDescription());
    }

    private QuizSummaryResponse toQuizSummary(Quiz quiz) {
        return new QuizSummaryResponse(
                quiz.getId(),
                quiz.getName(),
                quiz.getSetName(),
                quiz.getDurationMinutes(),
                quiz.getOptionCount(),
                quiz.getExam().getId(),
                quiz.getExam().getName(),
                quiz.getSubject().getName(),
                quiz.getTopic() != null ? quiz.getTopic().getName() : null);
    }
}
