import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-results',
  standalone: true,
  imports: [NgFor, MatButtonModule, MatIconModule],
  templateUrl: './results.component.html'
})
export class ResultsComponent {
  rows = [
    { rank: 1, student: 'Aditi Sharma', exam: 'BPSC TRE 4.0', quiz: 'Java Set 1', score: '92%' },
    { rank: 2, student: 'Rahul Kumar', exam: 'BPSC TRE 4.0', quiz: 'Java Set 2', score: '88%' }
  ];
}
