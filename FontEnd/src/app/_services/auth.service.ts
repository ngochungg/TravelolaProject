import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TokenStorageService } from '../_services/token-storage.service';
const AUTH_API = 'http://localhost:8080/api/auth/';
const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};
@Injectable({
  providedIn: 'root'
})
export class AuthService {
  currentUser: any;
  
  constructor(private token: TokenStorageService,private http: HttpClient) { }
  
  getTest(): Observable<any> {
    return this.http.get(AUTH_API + 'test123', { responseType: 'text' });
  }
  
  login(username: string, password: string): Observable<any> {
    return this.http.post(AUTH_API + 'signin', {
      username,
      password
    }, httpOptions);
  }
  register(username: string, email: string, password: string, firstName: string,lastName: string, phone: string, imageUrl: string): Observable<any> {
    return this.http.post(AUTH_API + 'signup', {
      username,
      email,
      password,
      firstName,
      lastName,
      phone,
      imageUrl

    }, httpOptions);
  }
  reloadPro(): Observable<any> {
    this.currentUser = this.token.getUser();
    return this.http.get(AUTH_API + 'viewProfile/' + this.currentUser.id);
  }
  getAllUsers() { 
  
    return this.http.get(AUTH_API + 'getAllUser');
   }
   allAdmin(): Observable<any> {
    
    return this.http.get(AUTH_API + 'viewAdmin/');
  }
  update( firstName: string,lastName: string,email: string, phone: string): Observable<any> {
    this.currentUser = this.token.getUser();
    return this.http.post(AUTH_API + 'updateUser/'+ this.currentUser.id , {
      firstName,
      lastName,
       email,
      phone,
    }, httpOptions);
  }
  updateIMG( imageUrl: string): Observable<any> {
    this.currentUser = this.token.getUser();
    return this.http.post(AUTH_API + 'uploadImage/'+ this.currentUser.id , {
     imageUrl,
    }, httpOptions);
  }
  loginFacebook(id : string,email: string, firstName: string,lastName: string, photoUrl: string): Observable<any> {
    return this.http.post(AUTH_API + 'loginFacebook', {
      id,
      email,
      firstName,
      lastName,
      photoUrl
    }, httpOptions);
  }
  loginGoogle(id : string,email: string, firstName: string,lastName: string, photoUrl: string): Observable<any> {
    return this.http.post(AUTH_API + 'loginGoogle', {
      id,
      email,
      firstName,
      lastName,
      photoUrl
    }, httpOptions);
  }
  
}