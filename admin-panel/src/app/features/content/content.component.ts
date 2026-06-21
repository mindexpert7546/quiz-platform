import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-content',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatIconModule],
  templateUrl: './content.component.html'
})
export class ContentComponent {
  materials = [
    { title: 'Java Notes', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'Java', type: 'PDF', status: 'Active' },
    { title: 'DBMS Normalization Video', exam: 'BPSC TRE 4.0', subject: 'Computer Science', topic: 'DBMS', type: 'Video', status: 'Active' }
  ];
}
