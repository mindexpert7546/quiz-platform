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
  templateUrl: './shell.component.html'
})
export class ShellComponent {
  private readonly auth = inject(AuthService);
  nav = nav;
  profile = this.auth.profile();

  logout() {
    this.auth.logout();
  }
}
