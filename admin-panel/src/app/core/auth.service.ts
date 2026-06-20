import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { tap } from 'rxjs';

export interface LoginRequest {
  email: string;
  password: string;
}

export interface AuthResponse {
  token: string;
  tokenType: string;
  name: string;
  email: string;
  role: string;
}

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly baseUrl = 'http://localhost:8080/api';
  private readonly tokenKey = 'exam_admin_token';
  private readonly profileKey = 'exam_admin_profile';

  constructor(private readonly http: HttpClient, private readonly router: Router) {}

  login(request: LoginRequest) {
    return this.http.post<AuthResponse>(`${this.baseUrl}/auth/login`, request).pipe(
      tap((response) => {
        localStorage.setItem(this.tokenKey, response.token);
        localStorage.setItem(this.profileKey, JSON.stringify(response));
      })
    );
  }

  isLoggedIn() {
    return Boolean(localStorage.getItem(this.tokenKey));
  }

  profile(): AuthResponse | null {
    const value = localStorage.getItem(this.profileKey);
    return value ? JSON.parse(value) as AuthResponse : null;
  }

  logout() {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem(this.profileKey);
    this.router.navigateByUrl('/login');
  }
}
