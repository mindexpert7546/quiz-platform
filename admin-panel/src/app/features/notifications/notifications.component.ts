import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-notifications',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatIconModule],
  templateUrl: './notifications.component.html'
})
export class NotificationsComponent {
  notifications = [
    { target: 'All', title: 'New Mock Test', message: 'BPSC TRE Mock Test 1 is live.', status: 'Published' },
    { target: 'Computer Science', title: 'Java Set 2', message: 'New Java practice set added.', status: 'Draft' }
  ];
}
