import { AsyncPipe, KeyValuePipe, NgFor } from '@angular/common';
import { Component, inject } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { ApiService } from '../../core/api.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [AsyncPipe, KeyValuePipe, NgFor, MatIconModule],
  template: `
    <section class="page-head">
      <h1>Dashboard</h1>
      <button class="primary-action"><mat-icon>download</mat-icon> Export</button>
    </section>

    <section class="metric-grid">
      <article *ngFor="let metric of metrics$ | async | keyvalue" class="metric-card">
        <span>{{ labels[metric.key] || metric.key }}</span>
        <strong>{{ metric.value }}</strong>
      </article>
    </section>

    <section class="workspace-grid">
      <div class="panel">
        <h2>Student Growth</h2>
        <div class="chart-bars"><i style="height: 42%"></i><i style="height: 62%"></i><i style="height: 50%"></i><i style="height: 78%"></i><i style="height: 91%"></i></div>
      </div>
      <div class="panel">
        <h2>Recent Activities</h2>
        <ul class="activity-list">
          <li>New BPSC TRE mock test drafted</li>
          <li>24 quiz attempts submitted today</li>
          <li>Computer Science notes updated</li>
        </ul>
      </div>
    </section>
  `
})
export class DashboardComponent {
  private readonly api = inject(ApiService);
  metrics$ = this.api.dashboard();
  labels: Record<string, string> = {
    totalStudents: 'Students',
    totalExams: 'Exams',
    totalSubjects: 'Subjects',
    totalTopics: 'Topics',
    totalQuestions: 'Questions',
    totalQuizzes: 'Quizzes',
    totalMockTests: 'Mock Tests',
    totalRevenue: 'Revenue'
  };
}
