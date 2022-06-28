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
  getAllUsers():Observable<any> { 
    return this.http.get(AUTH_API + 'getAllUser');
   }
  getWards(): Observable<any> {
    return this.http.get(AUTH_API + 'getAllWard');
  }
  getDistrict(): Observable<any> {
    return this.http.get(AUTH_API + 'getAllDistrict');
  }
  getProvince(): Observable<any> {
    return this.http.get(AUTH_API + 'getAllProvince');
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
  //lock user
  lockUser(id: string): Observable<any> {
    return this.http.post(AUTH_API + 'lockUser/'+ id, {
    }, httpOptions);
  }
  //unlock user
  unlockUser(id: string): Observable<any> {
    return this.http.post(AUTH_API + 'unlockUser/'+ id, {
    }, httpOptions);
  }
  //register hotel
  registerhotel(hotelName:string, email:string,phone:string, username:string, password:string, contactName:string, decription:string, street:string,ward:string,district:string,province:string, images:File[]): Observable<any>{
    const formData = new FormData();
    //add Multiple files to formdata
    for (let i = 0; i < images.length; i++) {
      formData.append('images', images[i], images[i].name);
    }
    formData.append('hotelName', hotelName);
    formData.append('email', email);
    formData.append('phone', phone);
    formData.append('username', username);
    formData.append('password', password);
    formData.append('contactName', contactName);
    formData.append('decription', decription);
    formData.append('street', street);
    formData.append('ward', ward);
    formData.append('district', district);
    formData.append('province', province);
    return this.http.post('http://localhost:8080/api/hotel/' + 'addHotel', formData);
  }
  
}