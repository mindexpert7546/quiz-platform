import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatTabsModule } from '@angular/material/tabs';

@Component({
  selector: 'app-masters',
  standalone: true,
  imports: [ReactiveFormsModule, NgFor, MatButtonModule, MatFormFieldModule, MatIconModule, MatInputModule, MatTabsModule],
  template: `
    <section class="page-head">
      <div>
        <h1>Masters</h1>
        <p>Manage exams, subjects, and topics from one place.</p>
      </div>
      <div class="action-row">
        <button mat-flat-button color="primary" type="button" (click)="showSubjectForm = false; showTopicForm = false">Exams</button>
      </div>
    </section>

    <mat-tab-group>
      <mat-tab label="Exams">
        <div class="action-row">
          <button mat-flat-button color="primary" type="button" (click)="showExamForm = !showExamForm">
            <mat-icon>{{ showExamForm ? 'close' : 'add' }}</mat-icon>
            {{ showExamForm ? 'Cancel' : 'Add Exam' }}
          </button>
        </div>
        <div *ngIf="showExamForm" class="form-shell">
          <form class="form-grid" [formGroup]="examForm" (ngSubmit)="saveExam()">
            <mat-form-field><mat-label>Exam Name</mat-label><input matInput formControlName="name"></mat-form-field>
            <mat-form-field><mat-label>Code</mat-label><input matInput formControlName="code"></mat-form-field>
            <mat-form-field class="wide"><mat-label>Description</mat-label><textarea matInput formControlName="description"></textarea></mat-form-field>
            <button mat-flat-button color="primary" type="submit">Save Exam</button>
          </form>
        </div>
        <div class="table-shell">
          <table><tr><th>Exam</th><th>Code</th><th>Description</th></tr><tr *ngFor="let item of exams"><td>{{ item.name }}</td><td>{{ item.code }}</td><td>{{ item.description }}</td></tr></table>
        </div>
      </mat-tab>
      <mat-tab label="Subjects">
        <div class="form-shell">
          <p class="section-note">Enter the exam and subject name below, then tap Save Subject.</p>
          <form [formGroup]="subjectForm" (ngSubmit)="saveSubject()" class="form-grid">
            <mat-form-field><mat-label>Exam Name</mat-label><input matInput formControlName="exam"></mat-form-field>
            <mat-form-field><mat-label>Subject Name</mat-label><input matInput formControlName="name"></mat-form-field>
            <button mat-flat-button color="primary" type="submit">Save Subject</button>
          </form>
        </div>
        <div class="table-shell">
          <table><tr><th>Exam</th><th>Subject</th><th>Status</th></tr><tr *ngFor="let row of subjects"><td>{{ row.exam }}</td><td>{{ row.name }}</td><td>Active</td></tr></table>
        </div>
      </mat-tab>
      <mat-tab label="Topics">
        <div class="form-shell">
          <p class="section-note">Add a new topic name below and tap Save Topic.</p>
          <form [formGroup]="topicForm" (ngSubmit)="saveTopic()" class="form-grid">
            <mat-form-field class="wide"><mat-label>Topic Name</mat-label><input matInput formControlName="name"></mat-form-field>
            <button mat-flat-button color="primary" type="submit">Save Topic</button>
          </form>
        </div>
        <div class="chip-row"><span *ngFor="let item of topics">{{ item }}</span></div>
      </mat-tab>
    </mat-tab-group>
  `
})
export class MastersComponent {
  examForm = new FormBuilder().nonNullable.group({
    name: ['', Validators.required],
    code: ['', Validators.required],
    description: ['']
  });

  subjectForm = new FormBuilder().nonNullable.group({
    exam: ['', Validators.required],
    name: ['', Validators.required]
  });

  topicForm = new FormBuilder().nonNullable.group({
    name: ['', Validators.required]
  });

  showExamForm = false;
  showSubjectForm = false;
  showTopicForm = false;

  exams = [
    { name: 'BPSC TRE 4.0', code: 'BPSC-TR4', description: 'Government job entrance' },
    { name: 'SSC CGL', code: 'SSC-CGL', description: 'Combined Graduate Level Exam' }
  ];

  subjects = [{ exam: 'BPSC TRE 4.0', name: 'Computer Science' }, { exam: 'SSC CGL', name: 'Mathematics' }];
  topics = ['Java', 'DBMS', 'Networking', 'Algebra', 'Current Affairs'];

  saveExam() {
    if (this.examForm.invalid) return;
    this.exams.push(this.examForm.getRawValue());
    this.examForm.reset({ name: '', code: '', description: '' });
    this.showExamForm = false;
  }

  saveSubject() {
    if (this.subjectForm.invalid) return;
    this.subjects.push(this.subjectForm.getRawValue());
    this.subjectForm.reset({ exam: '', name: '' });
    this.showSubjectForm = false;
  }

  saveTopic() {
    if (this.topicForm.invalid) return;
    this.topics.push(this.topicForm.getRawValue().name);
    this.topicForm.reset({ name: '' });
    this.showTopicForm = false;
  }
}
