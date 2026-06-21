import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { appConfig } from './app-config';

export interface Page<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  number: number;
}

@Injectable({ providedIn: 'root' })
export class ApiService {
  private readonly baseUrl = appConfig.apiBaseUrl;

  constructor(private readonly http: HttpClient) {}

  dashboard() {
    return this.http.get<Record<string, number>>(`${this.baseUrl}/dashboard/summary`);
  }

  list<T>(path: string, page = 0, size = 20) {
    const params = new HttpParams().set('page', page).set('size', size).set('sort', 'createdAt,desc');
    return this.http.get<Page<T>>(`${this.baseUrl}${path}`, { params });
  }

  create<T>(path: string, body: unknown) {
    return this.http.post<T>(`${this.baseUrl}${path}`, body);
  }
}
