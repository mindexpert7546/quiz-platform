import { Component } from '@angular/core';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { MatInputModule } from '@angular/material/input';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';

@Component({
  selector: 'app-settings',
  standalone: true,
  imports: [ReactiveFormsModule, MatInputModule, MatSlideToggleModule],
  templateUrl: './settings.component.html'
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
