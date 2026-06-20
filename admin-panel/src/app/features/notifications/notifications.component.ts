import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-notifications',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatIconModule],
  template: `
    <section class="page-head">
      <h1>Notifications</h1>
      <button mat-flat-button color="primary"><mat-icon>send</mat-icon> Send</button>
    </section>
    <section class="kanban">
      <article *ngFor="let item of notifications" class="work-card">
        <span>{{ item.target }}</span>
        <h2>{{ item.title }}</h2>
        <p>{{ item.message }}</p>
        <div class="status-row"><b>{{ item.status }}</b><button mat-icon-button><mat-icon>campaign</mat-icon></button></div>
      </article>
    </section>
  `
})
export class NotificationsComponent {
  notifications = [
    { target: 'All', title: 'New Mock Test', message: 'BPSC TRE Mock Test 1 is live.', status: 'Published' },
    { target: 'Computer Science', title: 'Java Set 2', message: 'New Java practice set added.', status: 'Draft' }
  ];
}
