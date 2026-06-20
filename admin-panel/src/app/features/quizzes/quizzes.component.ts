import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-quizzes',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatIconModule],
  template: `
    <section class="page-head">
      <h1>Quiz and Mock Tests</h1>
      <button mat-flat-button color="primary"><mat-icon>add</mat-icon> Create</button>
    </section>
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
  items = [
    { type: 'Topic Quiz', set: 'Set 1', name: 'Java Basics', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', duration: 20, access: 'Free', questions: 25, optionCount: 4, status: 'Draft' },
    { type: 'Topic Quiz', set: 'Set 2', name: 'Java OOP Practice', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', duration: 25, access: 'Paid', questions: 30, optionCount: 5, status: 'Published' },
    { type: 'Topic Quiz', set: 'Set 3', name: 'Java Collections', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', duration: 25, access: 'Paid', questions: 30, optionCount: 4, status: 'Draft' },
    { type: 'Mock Test', set: 'Full Length', name: 'Mock Test 1', exam: 'BPSC TRE 4.0', subject: 'All', topic: 'All', duration: 120, access: 'Paid', questions: 120, optionCount: 5, status: 'Published' }
  ];
}
