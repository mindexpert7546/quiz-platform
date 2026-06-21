import { NgFor } from '@angular/common';
import { Component, inject, OnInit } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { ApiService } from '../../core/api.service';

interface QuizItem {
  type: string;
  set: string;
  name: string;
  exam: string;
  subject: string;
  topic: string;
  duration: number;
  access: string;
  questions: number;
  optionCount: number;
  status: string;
}

@Component({
  selector: 'app-quizzes',
  standalone: true,
  imports: [NgFor, ReactiveFormsModule, MatButtonModule, MatFormFieldModule, MatIconModule, MatInputModule],
  templateUrl: './quizzes.component.html'
})

export class QuizzesComponent implements OnInit {
  showCreateForm = false;
  private readonly api = inject(ApiService);

  quizForm = new FormBuilder().nonNullable.group({
    name: ['', Validators.required],
    exam: ['', Validators.required],
    subject: ['', Validators.required],
    topic: ['', Validators.required],
    duration: [30, Validators.required],
    questions: [10, Validators.required]
  });

  items: QuizItem[] = [];

  ngOnInit(): void {
    this.api.list<any>('/public/quizzes').subscribe({
      next: (page) => {
        this.items = (page?.content || []).map((q: any) => ({
          type: q.setName ? 'Topic Quiz' : 'Quiz',
          set: q.setName || `Set ${q.setNumber || 1}`,
          name: q.name,
          exam: q.examName || q.exam?.name || '',
          subject: q.subject || q.subject?.name || '',
          topic: q.topic || q.topic || '',
          duration: q.durationMinutes || q.durationMinutes || 0,
          access: q.accessType || 'Free',
          questions: q.questionCount || q.questions || 0,
          optionCount: q.optionCount || 4,
          status: 'Unknown'
        }));
      },
      error: () => {
        // fallback sample data
        this.items = [
          { type: 'Topic Quiz', set: 'Set 1', name: 'Java Basics', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', duration: 20, access: 'Free', questions: 25, optionCount: 4, status: 'Draft' },
          { type: 'Topic Quiz', set: 'Set 2', name: 'Java OOP Practice', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', duration: 25, access: 'Paid', questions: 30, optionCount: 5, status: 'Published' }
        ];
      }
    });
  }

  saveQuiz() {
    if (this.quizForm.invalid) return;
    const value = this.quizForm.getRawValue();
    // attempt server create (best-effort); if it fails, fall back to local list
    const payload = {
      name: value.name,
      setName: value.name,
      setNumber: 1,
      examId: null,
      subjectId: null,
      topicId: null,
      durationMinutes: value.duration,
      optionCount: 4,
      totalMarks: 0,
      passingMarks: 0,
      accessType: 'FREE',
      questionIds: []
    };
    this.api.create<any>('/quizzes', payload).subscribe({
      next: (created) => {
        this.items.unshift({ type: 'Topic Quiz', set: 'New', name: created.name || value.name, exam: created.exam?.name || value.exam, subject: created.subject?.name || value.subject, topic: created.topic?.name || value.topic, duration: created.durationMinutes || value.duration, access: created.accessType || 'Draft', questions: created.questionCount || 0, optionCount: created.optionCount || 4, status: 'Draft' });
        this.quizForm.reset({ name: '', exam: '', subject: '', topic: '', duration: 30, questions: 10 });
        this.showCreateForm = false;
      },
      error: () => {
        // fallback local
        this.items.push({ type: 'Topic Quiz', set: 'New', name: value.name, exam: value.exam, subject: value.subject, topic: value.topic, duration: value.duration, access: 'Draft', questions: value.questions, optionCount: 4, status: 'Draft' });
        this.quizForm.reset({ name: '', exam: '', subject: '', topic: '', duration: 30, questions: 10 });
        this.showCreateForm = false;
      }
    });
  }
}
