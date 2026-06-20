import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-students',
  standalone: true,
  imports: [NgFor, MatIconModule],
  template: `
    <section class="page-head"><h1>Students</h1></section>
    <div class="table-shell">
      <table>
        <tr><th>Name</th><th>Email</th><th>Subscription</th><th>Attempts</th><th>Status</th></tr>
        <tr *ngFor="let student of students">
          <td>{{ student.name }}</td><td>{{ student.email }}</td><td>{{ student.plan }}</td><td>{{ student.attempts }}</td><td>{{ student.status }}</td>
        </tr>
      </table>
    </div>
  `
})
export class StudentsComponent {
  students = [
    { name: 'Aditi Sharma', email: 'aditi@example.com', plan: 'Gold', attempts: 18, status: 'Active' },
    { name: 'Rahul Kumar', email: 'rahul@example.com', plan: 'Free', attempts: 4, status: 'Active' }
  ];
}
