import { NgFor } from '@angular/common';
import { Component, inject, OnInit } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { ApiService } from '../../core/api.service';

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

export class QuestionsComponent implements OnInit {
  private readonly api = inject(ApiService);

  showQuestionForm = false;

  questionForm = new FormBuilder().nonNullable.group({
    text: ['', Validators.required],
    exam: ['', Validators.required],
    topic: ['', Validators.required],
    set: ['', Validators.required],
    optionCount: [4, Validators.required],
    level: ['', Validators.required]
  });
  questions: Question[] = [];

  ngOnInit(): void {
    this.api.list<any>('/questions').subscribe({
      next: (page) => {
        this.questions = (page?.content || []).map((q: any) => ({
          text: q.questionText,
          exam: q.exam?.name || '',
          topic: q.topic?.name || '',
          set: (q.setName || 'Set 1'),
          optionCount: q.optionE ? 5 : 4,
          level: q.difficultyLevel?.name || ''
        }));
      },
      error: () => {
        // fallback sample data
        this.questions = [
          { text: 'Which Java keyword prevents inheritance?', exam: 'BPSC TRE 4.0', topic: 'Java', set: 'Set 1', optionCount: 4, level: 'Easy' },
          { text: 'Which concept allows method overloading?', exam: 'BPSC TRE 4.0', topic: 'Java', set: 'Set 2', optionCount: 5, level: 'Medium' },
          { text: 'What does 3NF remove from a relation?', exam: 'BPSC TRE 4.0', topic: 'DBMS', set: 'Set 1', optionCount: 4, level: 'Medium' }
        ];
      }
    });
  }

  saveQuestion() {
    if (this.questionForm.invalid) return;
    const payload = {
      // map frontend form to server DTO where possible; using placeholder ids where not picked
      examId: null,
      subjectId: null,
      topicId: null,
      difficultyLevelId: null,
      questionTypeId: null,
      questionText: this.questionForm.getRawValue().text,
      optionA: null,
      optionB: null,
      optionC: null,
      optionD: null,
      optionE: null,
      correctAnswer: '',
      explanation: '',
      marks: 1
    };
    this.api.create<any>('/questions', payload).subscribe({
      next: (created) => {
        // append a lightweight representation
        this.questions.unshift({
          text: created.questionText || payload.questionText,
          exam: created.exam?.name || this.questionForm.getRawValue().exam,
          topic: created.topic?.name || this.questionForm.getRawValue().topic,
          set: this.questionForm.getRawValue().set,
          optionCount: this.questionForm.getRawValue().optionCount,
          level: this.questionForm.getRawValue().level
        });
        this.questionForm.reset({ text: '', exam: '', topic: '', set: '', optionCount: 4, level: '' });
        this.showQuestionForm = false;
      },
      error: () => {
        // fallback: push locally
        this.questions.unshift(this.questionForm.getRawValue());
        this.questionForm.reset({ text: '', exam: '', topic: '', set: '', optionCount: 4, level: '' });
        this.showQuestionForm = false;
      }
    });
  }
}
