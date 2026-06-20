import { Component } from '@angular/core';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { MatInputModule } from '@angular/material/input';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';

@Component({
  selector: 'app-settings',
  standalone: true,
  imports: [ReactiveFormsModule, MatInputModule, MatSlideToggleModule],
  template: `
    <section class="page-head"><h1>Settings</h1></section>
    <form class="form-grid" [formGroup]="form">
      <mat-form-field><mat-label>Application Name</mat-label><input matInput formControlName="appName"></mat-form-field>
      <mat-form-field><mat-label>Contact Email</mat-label><input matInput formControlName="email"></mat-form-field>
      <mat-form-field><mat-label>SMTP Host</mat-label><input matInput formControlName="smtpHost"></mat-form-field>
      <mat-form-field><mat-label>Razorpay Key</mat-label><input matInput formControlName="razorpayKey"></mat-form-field>
      <mat-slide-toggle formControlName="emailVerification">Email Verification</mat-slide-toggle>
      <mat-slide-toggle formControlName="maintenance">Maintenance Mode</mat-slide-toggle>
    </form>
  `
})
export class SettingsComponent {
  form = new FormBuilder().nonNullable.group({
    appName: ['Exam Preparation Platform'],
    email: ['support@example.com'],
    smtpHost: ['smtp.example.com'],
    razorpayKey: [''],
    emailVerification: [true],
    maintenance: [false]
  });
}
