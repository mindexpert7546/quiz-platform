import { Component } from '@angular/core';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { MatInputModule } from '@angular/material/input';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';

@Component({
  selector: 'app-tools',
  standalone: true,
  imports: [ReactiveFormsModule, MatInputModule, MatSlideToggleModule],
  template: `
    <section class="page-head"><h1>Tools Configuration</h1></section>
    <form class="form-grid" [formGroup]="form">
      <mat-form-field><mat-label>SMTP Host</mat-label><input matInput formControlName="smtpHost"></mat-form-field>
      <mat-form-field><mat-label>SMTP Port</mat-label><input matInput formControlName="smtpPort"></mat-form-field>
      <mat-form-field><mat-label>SMS Provider</mat-label><input matInput formControlName="smsProvider"></mat-form-field>
      <mat-form-field><mat-label>Firebase Project Id</mat-label><input matInput formControlName="firebaseProjectId"></mat-form-field>
      <mat-form-field><mat-label>Razorpay Key</mat-label><input matInput formControlName="razorpayKey"></mat-form-field>
      <mat-form-field><mat-label>Storage Provider</mat-label><input matInput formControlName="storageProvider"></mat-form-field>
      <mat-slide-toggle formControlName="sslEnabled">SMTP SSL</mat-slide-toggle>
    </form>
  `
})
export class ToolsComponent {
  form = new FormBuilder().nonNullable.group({
    smtpHost: ['smtp.example.com'],
    smtpPort: ['587'],
    smsProvider: [''],
    firebaseProjectId: [''],
    razorpayKey: [''],
    storageProvider: ['local'],
    sslEnabled: [true]
  });
}
