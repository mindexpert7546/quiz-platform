import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-content',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatIconModule],
  template: `
    <section class="page-head">
      <h1>Study Materials</h1>
      <button mat-flat-button color="primary"><mat-icon>upload_file</mat-icon> Upload</button>
    </section>
    <div class="table-shell">
      <table>
        <tr><th>Title</th><th>Exam</th><th>Subject</th><th>Topic</th><th>Type</th><th>Status</th></tr>
        <tr *ngFor="let item of materials"><td>{{ item.title }}</td><td>{{ item.exam }}</td><td>{{ item.subject }}</td><td>{{ item.topic }}</td><td>{{ item.type }}</td><td>{{ item.status }}</td></tr>
      </table>
    </div>
  `
})
export class ContentComponent {
  materials = [
    { title: 'Java Notes', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', type: 'PDF', status: 'Active' },
    { title: 'DBMS Normalization Video', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'DBMS', type: 'Video', status: 'Active' }
  ];
}
