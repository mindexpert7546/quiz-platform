import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';

@Component({
  selector: 'app-security',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatCheckboxModule, MatIconModule, MatSelectModule],
  templateUrl: './security.component.html'
})
export class SecurityComponent {
  users = [
    { name: 'Super Admin', email: 'admin@example.com', role: 'SUPER_ADMIN', promoteTo: 'SUPER_ADMIN', status: 'Active' },
    { name: 'Content Lead', email: 'content@example.com', role: 'CONTENT_MANAGER', promoteTo: 'ADMIN', status: 'Active' },
    { name: 'Aditi Sharma', email: 'aditi@example.com', role: 'STUDENT', promoteTo: 'ADMIN', status: 'Active' }
  ];

  permissions = [
    { module: 'Dashboard', enabled: true },
    { module: 'Masters', enabled: true },
    { module: 'Questions', enabled: true },
    { module: 'Quizzes', enabled: true },
    { module: 'Mock Tests', enabled: true },
    { module: 'Students', enabled: true },
    { module: 'Results', enabled: true },
    { module: 'Payments', enabled: false },
    { module: 'Content', enabled: true },
    { module: 'Notifications', enabled: false },
    { module: 'Tools', enabled: false },
    { module: 'Settings', enabled: false }
  ];
}
