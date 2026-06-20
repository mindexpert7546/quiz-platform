import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatInputModule } from '@angular/material/input';
import { MatTabsModule } from '@angular/material/tabs';

@Component({
  selector: 'app-masters',
  standalone: true,
  imports: [ReactiveFormsModule, NgFor, MatButtonModule, MatInputModule, MatTabsModule],
  template: `
    <section class="page-head"><h1>Masters</h1></section>
    <mat-tab-group>
      <mat-tab label="Exams">
        <form class="form-grid" [formGroup]="examForm">
          <mat-form-field><mat-label>Exam Name</mat-label><input matInput formControlName="name"></mat-form-field>
          <mat-form-field><mat-label>Code</mat-label><input matInput formControlName="code"></mat-form-field>
          <mat-form-field class="wide"><mat-label>Description</mat-label><textarea matInput formControlName="description"></textarea></mat-form-field>
          <button mat-flat-button color="primary">Save Exam</button>
        </form>
      </mat-tab>
      <mat-tab label="Subjects">
        <div class="table-shell">
          <table><tr><th>Exam</th><th>Subject</th><th>Status</th></tr><tr *ngFor="let row of samples"><td>{{ row.exam }}</td><td>{{ row.name }}</td><td>Active</td></tr></table>
        </div>
      </mat-tab>
      <mat-tab label="Topics">
        <div class="chip-row"><span>Java</span><span>DBMS</span><span>Networking</span><span>Algebra</span><span>Current Affairs</span></div>
      </mat-tab>
    </mat-tab-group>
  `
})
export class MastersComponent {
  examForm = new FormBuilder().nonNullable.group({
    name: ['', Validators.required],
    code: ['', Validators.required],
    description: ['']
  });
  samples = [{ exam: 'BPSC TRE 4.0', name: 'Computer Science' }, { exam: 'SSC CGL', name: 'Mathematics' }];
}
