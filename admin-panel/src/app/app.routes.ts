import { Routes } from '@angular/router';
import { DashboardComponent } from './features/dashboard/dashboard.component';
import { MastersComponent } from './features/masters/masters.component';
import { QuestionsComponent } from './features/questions/questions.component';
import { QuizzesComponent } from './features/quizzes/quizzes.component';
import { StudentsComponent } from './features/students/students.component';
import { SettingsComponent } from './features/settings/settings.component';
import { ResultsComponent } from './features/results/results.component';
import { SubscriptionsComponent } from './features/subscriptions/subscriptions.component';
import { ContentComponent } from './features/content/content.component';
import { NotificationsComponent } from './features/notifications/notifications.component';
import { SecurityComponent } from './features/security/security.component';
import { ToolsComponent } from './features/tools/tools.component';
import { LoginComponent } from './features/login/login.component';
import { ShellComponent } from './core/shell.component';
import { authChildGuard } from './core/auth.guard';
import { guestGuard } from './core/guest.guard';

export const routes: Routes = [
  { path: 'login', component: LoginComponent, canActivate: [guestGuard] },
  {
    path: '',
    component: ShellComponent,
    canActivateChild: [authChildGuard],
    children: [
      { path: '', pathMatch: 'full', redirectTo: 'dashboard' },
      { path: 'dashboard', component: DashboardComponent },
      { path: 'masters', component: MastersComponent },
      { path: 'questions', component: QuestionsComponent },
      { path: 'quizzes', component: QuizzesComponent },
      { path: 'students', component: StudentsComponent },
      { path: 'results', component: ResultsComponent },
      { path: 'subscriptions', component: SubscriptionsComponent },
      { path: 'content', component: ContentComponent },
      { path: 'notifications', component: NotificationsComponent },
      { path: 'tools', component: ToolsComponent },
      { path: 'security', component: SecurityComponent },
      { path: 'settings', component: SettingsComponent }
    ]
  },
  { path: '**', redirectTo: 'dashboard' }
];
