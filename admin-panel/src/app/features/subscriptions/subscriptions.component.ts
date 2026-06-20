import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-subscriptions',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatIconModule],
  template: `
    <section class="page-head">
      <h1>Subscriptions and Payments</h1>
      <button mat-flat-button color="primary"><mat-icon>add</mat-icon> Plan</button>
    </section>
    <section class="kanban">
      <article *ngFor="let plan of plans" class="work-card">
        <span>{{ plan.status }}</span>
        <h2>{{ plan.name }}</h2>
        <p>Rs {{ plan.price }} - {{ plan.duration }} days</p>
        <div class="status-row"><b>{{ plan.users }} students</b><button mat-icon-button><mat-icon>edit</mat-icon></button></div>
      </article>
    </section>
  `
})
export class SubscriptionsComponent {
  plans = [
    { name: 'Free', price: 0, duration: 0, users: 1200, status: 'Active' },
    { name: 'Premium', price: 499, duration: 30, users: 340, status: 'Active' },
    { name: 'Gold', price: 1499, duration: 180, users: 88, status: 'Active' }
  ];
}
