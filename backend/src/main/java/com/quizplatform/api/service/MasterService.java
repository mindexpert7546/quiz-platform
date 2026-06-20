package com.quizplatform.api.service;

import com.quizplatform.api.dto.MasterDtos.ExamRequest;
import com.quizplatform.api.dto.MasterDtos.SubjectRequest;
import com.quizplatform.api.dto.MasterDtos.TopicRequest;
import com.quizplatform.api.entity.Exam;
import com.quizplatform.api.entity.Subject;
import com.quizplatform.api.entity.Topic;
import com.quizplatform.api.exception.ResourceNotFoundException;
import com.quizplatform.api.repository.ExamRepository;
import com.quizplatform.api.repository.SubjectRepository;
import com.quizplatform.api.repository.TopicRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MasterService {
    private final ExamRepository exams;
    private final SubjectRepository subjects;
    private final TopicRepository topics;

    public MasterService(ExamRepository exams, SubjectRepository subjects, TopicRepository topics) {
        this.exams = exams;
        this.subjects = subjects;
        this.topics = topics;
    }

    public Page<Exam> exams(Pageable pageable) {
        return exams.findAll(pageable);
    }

    @Transactional
    public Exam createExam(ExamRequest request) {
        Exam exam = new Exam();
        exam.setName(request.name());
        exam.setCode(request.code());
        exam.setDescription(request.description());
        exam.setThumbnailUrl(request.thumbnailUrl());
        exam.setBannerUrl(request.bannerUrl());
        return exams.save(exam);
    }

    @Transactional
    public Subject createSubject(SubjectRequest request) {
        Subject subject = new Subject();
        subject.setExam(exams.findById(request.examId()).orElseThrow(() -> new ResourceNotFoundException("Exam not found")));
        subject.setName(request.name());
        subject.setDescription(request.description());
        return subjects.save(subject);
    }

    @Transactional
    public Topic createTopic(TopicRequest request) {
        Topic topic = new Topic();
        topic.setExam(exams.findById(request.examId()).orElseThrow(() -> new ResourceNotFoundException("Exam not found")));
        topic.setSubject(subjects.findById(request.subjectId()).orElseThrow(() -> new ResourceNotFoundException("Subject not found")));
        topic.setName(request.name());
        topic.setDescription(request.description());
        return topics.save(topic);
    }
}
