import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';

interface Question {
  text: string;
  exam: string;
  topic: string;
  set: string;
  optionCount: number;
  level: string;
}

@Component({
  selector: 'app-questions',
  standalone: true,
  imports: [NgFor, ReactiveFormsModule, MatButtonModule, MatFormFieldModule, MatIconModule, MatInputModule],
  templateUrl: './questions.component.html'
})

export class QuestionsComponent {
  showQuestionForm = false;

  questionForm = new FormBuilder().nonNullable.group({
    text: ['', Validators.required],
    exam: ['', Validators.required],
    topic: ['', Validators.required],
    set: ['', Validators.required],
    optionCount: [4, Validators.required],
    level: ['', Validators.required]
  });

  questions: Question[] = [
    { text: 'Which Java keyword prevents inheritance?', exam: 'BPSC TRE 4.0', topic: 'Java', set: 'Set 1', optionCount: 4, level: 'Easy' },
    { text: 'Which concept allows method overloading?', exam: 'BPSC TRE 4.0', topic: 'Java', set: 'Set 2', optionCount: 5, level: 'Medium' },
    { text: 'What does 3NF remove from a relation?', exam: 'BPSC TRE 4.0', topic: 'DBMS', set: 'Set 1', optionCount: 4, level: 'Medium' }
  ];

  saveQuestion() {
    if (this.questionForm.invalid) return;
    this.questions.push(this.questionForm.getRawValue());
    this.questionForm.reset({ text: '', exam: '', topic: '', set: '', optionCount: 4, level: '' });
    this.showQuestionForm = false;
  }
}
