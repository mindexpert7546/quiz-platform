import { NgFor } from '@angular/common';
import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatToolbarModule } from '@angular/material/toolbar';
import { AuthService } from './auth.service';

const nav = [
  { path: '/dashboard', icon: 'dashboard', label: 'Dashboard' },
  { path: '/masters', icon: 'folder_open', label: 'Masters' },
  { path: '/questions', icon: 'quiz', label: 'Questions' },
  { path: '/quizzes', icon: 'assignment', label: 'Quizzes' },
  { path: '/students', icon: 'groups', label: 'Students' },
  { path: '/results', icon: 'leaderboard', label: 'Results' },
  { path: '/subscriptions', icon: 'payments', label: 'Payments' },
  { path: '/content', icon: 'menu_book', label: 'Content' },
  { path: '/notifications', icon: 'campaign', label: 'Notify' },
  { path: '/tools', icon: 'tune', label: 'Tools' },
  { path: '/security', icon: 'admin_panel_settings', label: 'Security' },
  { path: '/settings', icon: 'settings', label: 'Settings' }
];

@Component({
  selector: 'app-shell',
  standalone: true,
  imports: [NgFor, RouterOutlet, RouterLink, RouterLinkActive, MatButtonModule, MatIconModule, MatListModule, MatSidenavModule, MatToolbarModule],
  template: `
    <mat-sidenav-container class="shell">
      <mat-sidenav #drawer mode="side" opened class="nav">
        <div class="brand">
          <mat-icon>school</mat-icon>
          <span>ExamOps</span>
        </div>
        <nav>
          <a mat-list-item *ngFor="let item of nav" [routerLink]="item.path" routerLinkActive="active">
            <mat-icon matListItemIcon>{{ item.icon }}</mat-icon>
            <span matListItemTitle>{{ item.label }}</span>
          </a>
        </nav>
      </mat-sidenav>
      <mat-sidenav-content>
        <mat-toolbar class="topbar">
          <button mat-icon-button class="menu-toggle" aria-label="Toggle navigation" (click)="drawer.toggle()">
            <mat-icon>menu</mat-icon>
          </button>
          <div>
            <strong>Exam Preparation Platform</strong>
            <small>{{ profile?.role || 'Admin' }}</small>
          </div>
          <span class="spacer"></span>
          <button mat-icon-button aria-label="Notifications"><mat-icon>notifications</mat-icon></button>
          <button mat-stroked-button type="button" (click)="logout()">
            <mat-icon>logout</mat-icon>
            Logout
          </button>
        </mat-toolbar>
        <main>
          <router-outlet />
        </main>
      </mat-sidenav-content>
    </mat-sidenav-container>
  `
})
export class ShellComponent {
  private readonly auth = inject(AuthService);
  nav = nav;
  profile = this.auth.profile();

  logout() {
    this.auth.logout();
  }
}
