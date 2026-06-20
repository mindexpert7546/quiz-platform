import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { AuthService } from '../../core/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [ReactiveFormsModule, MatButtonModule, MatIconModule, MatInputModule],
  template: `
    <section class="login-page">
      <div class="login-panel">
        <div class="login-brand">
          <mat-icon>school</mat-icon>
          <span>ExamOps</span>
        </div>
        <h1>Admin Login</h1>
        <p>Use the default Super Admin account on first run.</p>

        <form [formGroup]="form" (ngSubmit)="submit()">
          <mat-form-field appearance="outline">
            <mat-label>Email</mat-label>
            <input matInput formControlName="email" autocomplete="email">
            <mat-icon matSuffix>mail</mat-icon>
          </mat-form-field>

          <mat-form-field appearance="outline">
            <mat-label>Password</mat-label>
            <input matInput type="password" formControlName="password" autocomplete="current-password">
            <mat-icon matSuffix>lock</mat-icon>
          </mat-form-field>

          <button mat-flat-button color="primary" type="submit" [disabled]="form.invalid || loading">
            <mat-icon>login</mat-icon>
            Login
          </button>
          <p class="error" *ngIf="error">{{ error }}</p>
        </form>

        <div class="default-login">
          <span>Default Super Admin</span>
          <code>admin@example.com / Admin&#64;12345</code>
        </div>
      </div>
    </section>
  `
})
export class LoginComponent {
  private readonly fb = inject(FormBuilder);
  private readonly auth = inject(AuthService);
  private readonly router = inject(Router);

  loading = false;
  error = '';
  form = this.fb.nonNullable.group({
    email: ['admin@example.com', [Validators.required, Validators.email]],
    password: ['Admin@12345', Validators.required]
  });

  submit() {
    if (this.form.invalid) {
      return;
    }
    this.loading = true;
    this.error = '';
    this.auth.login(this.form.getRawValue()).subscribe({
      next: () => this.router.navigateByUrl('/dashboard'),
      error: () => {
        this.loading = false;
        this.error = 'Login failed. Check backend is running and credentials are correct.';
      }
    });
  }
}
