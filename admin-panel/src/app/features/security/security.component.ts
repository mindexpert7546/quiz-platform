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
  template: `
    <section class="page-head">
      <h1>Security</h1>
      <button mat-flat-button color="primary"><mat-icon>person_add</mat-icon> Add Admin</button>
    </section>

    <section class="workspace-grid">
      <div class="table-shell">
        <h2>Users and Promotion</h2>
        <table>
          <tr><th>User</th><th>Email</th><th>Current Role</th><th>Promote As</th><th>Status</th></tr>
          <tr *ngFor="let user of users">
            <td>{{ user.name }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.role }}</td>
            <td>
              <mat-select [value]="user.promoteTo" aria-label="Promote user role">
                <mat-option value="STUDENT">Student</mat-option>
                <mat-option value="CONTENT_MANAGER">Content Manager</mat-option>
                <mat-option value="ADMIN">Admin</mat-option>
                <mat-option value="SUPER_ADMIN">Super Admin</mat-option>
              </mat-select>
            </td>
            <td>{{ user.status }}</td>
          </tr>
        </table>
      </div>

      <div class="panel">
        <h2>Admin Module Access</h2>
        <div class="permission-grid">
          <label *ngFor="let permission of permissions">
            <mat-checkbox [checked]="permission.enabled">{{ permission.module }}</mat-checkbox>
          </label>
        </div>
        <button mat-flat-button color="primary"><mat-icon>save</mat-icon> Save Access</button>
      </div>
    </section>
  `
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
