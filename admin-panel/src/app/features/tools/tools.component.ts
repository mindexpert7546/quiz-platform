import { Component } from '@angular/core';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { MatInputModule } from '@angular/material/input';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';

@Component({
  selector: 'app-tools',
  standalone: true,
  imports: [ReactiveFormsModule, MatInputModule, MatSlideToggleModule],
  templateUrl: './tools.component.html'
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
