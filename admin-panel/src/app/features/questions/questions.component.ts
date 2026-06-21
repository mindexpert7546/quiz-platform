import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';

interface Question {
  text: string;
  exam: string;
  topic: string;
  set: string;
  optionCount: number;
  level: string;
}

@Component({
  selector: 'app-questions',
  standalone: true,
  imports: [NgFor, ReactiveFormsModule, MatButtonModule, MatFormFieldModule, MatIconModule, MatInputModule],
  template: `
    <section class="page-head">
      <div>
        <h1>Question Bank</h1>
        <p>Manage questions and add new questions quickly.</p>
      </div>
      <div class="action-row">
        <button mat-stroked-button type="button"><mat-icon>download</mat-icon> Template</button>
        <button mat-stroked-button type="button"><mat-icon>upload_file</mat-icon> Bulk Upload</button>
        <button mat-flat-button color="primary" type="button" (click)="showQuestionForm = !showQuestionForm"><mat-icon>{{ showQuestionForm ? 'close' : 'add' }}</mat-icon> {{ showQuestionForm ? 'Cancel' : 'Add Question' }}</button>
      </div>
    </section>
    <div *ngIf="showQuestionForm" class="form-shell">
        <form [formGroup]="questionForm" (ngSubmit)="saveQuestion()" class="form-grid">
          <mat-form-field><mat-label>Question Text</mat-label><input matInput formControlName="text"></mat-form-field>
          <mat-form-field><mat-label>Exam</mat-label><input matInput formControlName="exam"></mat-form-field>
          <mat-form-field><mat-label>Topic</mat-label><input matInput formControlName="topic"></mat-form-field>
          <mat-form-field><mat-label>Quiz Set</mat-label><input matInput formControlName="set"></mat-form-field>
          <mat-form-field><mat-label>Options</mat-label><input matInput type="number" formControlName="optionCount"></mat-form-field>
          <mat-form-field><mat-label>Difficulty</mat-label><input matInput formControlName="level"></mat-form-field>
          <button mat-flat-button color="primary" type="submit">Save Question</button>
        </form>
      </div>
    <div class="table-shell">
      <table>
        <tr><th>Question</th><th>Exam</th><th>Topic</th><th>Quiz Set</th><th>Options</th><th>Difficulty</th><th>Actions</th></tr>
        <tr *ngFor="let question of questions">
          <td>{{ question.text }}</td><td>{{ question.exam }}</td><td>{{ question.topic }}</td><td>{{ question.set }}</td><td>{{ question.optionCount }}</td><td>{{ question.level }}</td>
          <td><button mat-icon-button><mat-icon>visibility</mat-icon></button><button mat-icon-button><mat-icon>content_copy</mat-icon></button></td>
        </tr>
      </table>
    </div>
  `
})

export class QuestionsComponent {
  showQuestionForm = false;

  questionForm = new FormBuilder().nonNullable.group({
    text: ['', Validators.required],
    exam: ['', Validators.required],
    topic: ['', Validators.required],
    set: ['', Validators.required],
    optionCount: [4, Validators.required],
    level: ['', Validators.required]
  });

  questions: Question[] = [
    { text: 'Which Java keyword prevents inheritance?', exam: 'BPSC TRE 4.0', topic: 'Java', set: 'Set 1', optionCount: 4, level: 'Easy' },
    { text: 'Which concept allows method overloading?', exam: 'BPSC TRE 4.0', topic: 'Java', set: 'Set 2', optionCount: 5, level: 'Medium' },
    { text: 'What does 3NF remove from a relation?', exam: 'BPSC TRE 4.0', topic: 'DBMS', set: 'Set 1', optionCount: 4, level: 'Medium' }
  ];

  saveQuestion() {
    if (this.questionForm.invalid) return;
    this.questions.push(this.questionForm.getRawValue());
    this.questionForm.reset({ text: '', exam: '', topic: '', set: '', optionCount: 4, level: '' });
    this.showQuestionForm = false;
  }
}
