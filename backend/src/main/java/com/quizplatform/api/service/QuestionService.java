package com.quizplatform.api.service;

import com.quizplatform.api.dto.QuestionDtos.QuestionRequest;
import com.quizplatform.api.entity.Question;
import com.quizplatform.api.exception.ResourceNotFoundException;
import com.quizplatform.api.repository.DifficultyLevelRepository;
import com.quizplatform.api.repository.ExamRepository;
import com.quizplatform.api.repository.QuestionRepository;
import com.quizplatform.api.repository.QuestionTypeRepository;
import com.quizplatform.api.repository.SubjectRepository;
import com.quizplatform.api.repository.TopicRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class QuestionService {
    private final QuestionRepository questions;
    private final ExamRepository exams;
    private final SubjectRepository subjects;
    private final TopicRepository topics;
    private final DifficultyLevelRepository difficultyLevels;
    private final QuestionTypeRepository questionTypes;

    public QuestionService(QuestionRepository questions, ExamRepository exams, SubjectRepository subjects,
                           TopicRepository topics, DifficultyLevelRepository difficultyLevels,
                           QuestionTypeRepository questionTypes) {
        this.questions = questions;
        this.exams = exams;
        this.subjects = subjects;
        this.topics = topics;
        this.difficultyLevels = difficultyLevels;
        this.questionTypes = questionTypes;
    }

    public Page<Question> list(Pageable pageable) {
        return questions.findAll(pageable);
    }

    @Transactional
    public Question create(QuestionRequest request) {
        Question question = new Question();
        question.setExam(exams.findById(request.examId()).orElseThrow(() -> new ResourceNotFoundException("Exam not found")));
        question.setSubject(subjects.findById(request.subjectId()).orElseThrow(() -> new ResourceNotFoundException("Subject not found")));
        question.setTopic(topics.findById(request.topicId()).orElseThrow(() -> new ResourceNotFoundException("Topic not found")));
        question.setDifficultyLevel(difficultyLevels.findById(request.difficultyLevelId()).orElseThrow(() -> new ResourceNotFoundException("Difficulty not found")));
        question.setQuestionType(questionTypes.findById(request.questionTypeId()).orElseThrow(() -> new ResourceNotFoundException("Question type not found")));
        question.setQuestionText(request.questionText());
        question.setOptionA(request.optionA());
        question.setOptionB(request.optionB());
        question.setOptionC(request.optionC());
        question.setOptionD(request.optionD());
        question.setOptionE(request.optionE());
        question.setCorrectAnswer(request.correctAnswer());
        question.setExplanation(request.explanation());
        question.setMarks(request.marks());
        return questions.save(question);
    }

    @Transactional
    public Question clone(Long id) {
        Question source = questions.findById(id).orElseThrow(() -> new ResourceNotFoundException("Question not found"));
        Question clone = new Question();
        clone.setExam(source.getExam());
        clone.setSubject(source.getSubject());
        clone.setTopic(source.getTopic());
        clone.setDifficultyLevel(source.getDifficultyLevel());
        clone.setQuestionType(source.getQuestionType());
        clone.setQuestionText(source.getQuestionText());
        clone.setOptionA(source.getOptionA());
        clone.setOptionB(source.getOptionB());
        clone.setOptionC(source.getOptionC());
        clone.setOptionD(source.getOptionD());
        clone.setOptionE(source.getOptionE());
        clone.setCorrectAnswer(source.getCorrectAnswer());
        clone.setExplanation(source.getExplanation());
        clone.setMarks(source.getMarks());
        return questions.save(clone);
    }
}
