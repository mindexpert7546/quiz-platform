import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-subscriptions',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatIconModule],
  templateUrl: './subscriptions.component.html'
})
export class SubscriptionsComponent {
  plans = [
    { name: 'Free', price: 0, duration: 0, users: 1200, status: 'Active' },
    { name: 'Premium', price: 499, duration: 30, users: 340, status: 'Active' },
    { name: 'Gold', price: 1499, duration: 180, users: 88, status: 'Active' }
  ];
}
