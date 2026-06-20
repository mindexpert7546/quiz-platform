import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-questions',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatIconModule],
  template: `
    <section class="page-head">
      <h1>Question Bank</h1>
      <div class="action-row">
        <button mat-stroked-button><mat-icon>download</mat-icon> Template</button>
        <button mat-stroked-button><mat-icon>upload_file</mat-icon> Bulk Upload</button>
        <button mat-flat-button color="primary"><mat-icon>add</mat-icon> Add Question</button>
      </div>
    </section>
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
  questions = [
    { text: 'Which Java keyword prevents inheritance?', exam: 'BPSC TRE 4.0', topic: 'Java', set: 'Set 1', optionCount: 4, level: 'Easy' },
    { text: 'Which concept allows method overloading?', exam: 'BPSC TRE 4.0', topic: 'Java', set: 'Set 2', optionCount: 5, level: 'Medium' },
    { text: 'What does 3NF remove from a relation?', exam: 'BPSC TRE 4.0', topic: 'DBMS', set: 'Set 1', optionCount: 4, level: 'Medium' }
  ];
}
