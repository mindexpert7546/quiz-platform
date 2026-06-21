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
  template: `
    <section class="page-head">
      <div>
        <h1>Quiz and Mock Tests</h1>
        <p>Create new quizzes and review existing mock tests.</p>
      </div>
      <button mat-flat-button color="primary" type="button" (click)="showCreateForm = !showCreateForm"><mat-icon>{{ showCreateForm ? 'close' : 'add' }}</mat-icon> {{ showCreateForm ? 'Cancel' : 'Create' }}</button>
    </section>
    <div *ngIf="showCreateForm" class="form-shell">
      <form [formGroup]="quizForm" (ngSubmit)="saveQuiz()" class="form-grid">
        <mat-form-field><mat-label>Quiz Name</mat-label><input matInput formControlName="name"></mat-form-field>
        <mat-form-field><mat-label>Exam</mat-label><input matInput formControlName="exam"></mat-form-field>
        <mat-form-field><mat-label>Subject</mat-label><input matInput formControlName="subject"></mat-form-field>
        <mat-form-field><mat-label>Topic</mat-label><input matInput formControlName="topic"></mat-form-field>
        <mat-form-field><mat-label>Duration</mat-label><input matInput type="number" formControlName="duration"></mat-form-field>
        <mat-form-field><mat-label>Questions</mat-label><input matInput type="number" formControlName="questions"></mat-form-field>
        <button mat-flat-button color="primary" type="submit">Save Quiz</button>
      </form>
    </div>
    <section class="kanban">
      <article *ngFor="let item of items" class="work-card">
        <span>{{ item.type }} / {{ item.set }}</span>
        <h2>{{ item.name }}</h2>
        <p>{{ item.exam }} - {{ item.subject }} - {{ item.topic }}</p>
        <p>{{ item.duration }} min - {{ item.access }} - {{ item.questions }} questions - {{ item.optionCount }} options</p>
        <div class="status-row"><b>{{ item.status }}</b><button mat-icon-button><mat-icon>publish</mat-icon></button></div>
      </article>
    </section>
  `
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
