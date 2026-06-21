import { AsyncPipe, KeyValuePipe, NgFor } from '@angular/common';
import { Component, inject } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { ApiService } from '../../core/api.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [AsyncPipe, KeyValuePipe, NgFor, MatIconModule],
  templateUrl: './dashboard.component.html'
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
