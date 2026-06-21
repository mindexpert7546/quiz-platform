import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatTabsModule } from '@angular/material/tabs';

@Component({
  selector: 'app-masters',
  standalone: true,
  imports: [ReactiveFormsModule, NgFor, MatButtonModule, MatFormFieldModule, MatIconModule, MatInputModule, MatTabsModule],
  templateUrl: './masters.component.html'
})
export class MastersComponent {
  examForm = new FormBuilder().nonNullable.group({
    name: ['', Validators.required],
    code: ['', Validators.required],
    description: ['']
  });

  subjectForm = new FormBuilder().nonNullable.group({
    exam: ['', Validators.required],
    name: ['', Validators.required]
  });

  topicForm = new FormBuilder().nonNullable.group({
    name: ['', Validators.required]
  });

  showExamForm = false;
  showSubjectForm = false;
  showTopicForm = false;

  exams = [
    { name: 'BPSC TRE 4.0', code: 'BPSC-TR4', description: 'Government job entrance' },
    { name: 'SSC CGL', code: 'SSC-CGL', description: 'Combined Graduate Level Exam' }
  ];

  subjects = [{ exam: 'BPSC TRE 4.0', name: 'Computer Science' }, { exam: 'SSC CGL', name: 'Mathematics' }];
  topics = ['Java', 'DBMS', 'Networking', 'Algebra', 'Current Affairs'];

  saveExam() {
    if (this.examForm.invalid) return;
    this.exams.push(this.examForm.getRawValue());
    this.examForm.reset({ name: '', code: '', description: '' });
    this.showExamForm = false;
  }

  saveSubject() {
    if (this.subjectForm.invalid) return;
    this.subjects.push(this.subjectForm.getRawValue());
    this.subjectForm.reset({ exam: '', name: '' });
    this.showSubjectForm = false;
  }

  saveTopic() {
    if (this.topicForm.invalid) return;
    this.topics.push(this.topicForm.getRawValue().name);
    this.topicForm.reset({ name: '' });
    this.showTopicForm = false;
  }
}
