import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';

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

export class QuizzesComponent {
  showCreateForm = false;

  quizForm = new FormBuilder().nonNullable.group({
    name: ['', Validators.required],
    exam: ['', Validators.required],
    subject: ['', Validators.required],
    topic: ['', Validators.required],
    duration: [30, Validators.required],
    questions: [10, Validators.required]
  });

  items: QuizItem[] = [
    { type: 'Topic Quiz', set: 'Set 1', name: 'Java Basics', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', duration: 20, access: 'Free', questions: 25, optionCount: 4, status: 'Draft' },
    { type: 'Topic Quiz', set: 'Set 2', name: 'Java OOP Practice', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', duration: 25, access: 'Paid', questions: 30, optionCount: 5, status: 'Published' },
    { type: 'Topic Quiz', set: 'Set 3', name: 'Java Collections', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', duration: 25, access: 'Paid', questions: 30, optionCount: 4, status: 'Draft' },
    { type: 'Mock Test', set: 'Full Length', name: 'Mock Test 1', exam: 'BPSC TRE 4.0', subject: 'All', topic: 'All', duration: 120, access: 'Paid', questions: 120, optionCount: 5, status: 'Published' }
  ];

  saveQuiz() {
    if (this.quizForm.invalid) return;
    const value = this.quizForm.getRawValue();
    this.items.push({
      type: 'Topic Quiz',
      set: 'New',
      name: value.name,
      exam: value.exam,
      subject: value.subject,
      topic: value.topic,
      duration: value.duration,
      access: 'Draft',
      questions: value.questions,
      optionCount: 4,
      status: 'Draft'
    });
    this.quizForm.reset({ name: '', exam: '', subject: '', topic: '', duration: 30, questions: 10 });
    this.showCreateForm = false;
  }
}
