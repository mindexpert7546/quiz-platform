import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-students',
  standalone: true,
  imports: [NgFor, MatIconModule],
  templateUrl: './students.component.html'
})
export class StudentsComponent {
  students = [
    { name: 'Aditi Sharma', email: 'aditi@example.com', plan: 'Gold', attempts: 18, status: 'Active' },
    { name: 'Rahul Kumar', email: 'rahul@example.com', plan: 'Free', attempts: 4, status: 'Active' }
  ];
}
