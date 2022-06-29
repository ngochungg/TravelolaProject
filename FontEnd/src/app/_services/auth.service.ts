import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TokenStorageService } from '../_services/token-storage.service';
const AUTH_API = 'http://localhost:8080/api/auth/';
const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};
interface FormType{
  hotelName: string;
  email: string;
  phone:string;
  username:string;
  password:string;
  contactName:string;
  decription:string;
  street:string;
  ward:string;
  district:string;
  province:string;
  images:File
}
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
  getWards(id: string): Observable<any> {
    return this.http.get(AUTH_API + 'getWard/'+id );
  }
  getDistrict(id: string): Observable<any> {
    return this.http.get(AUTH_API + 'getAllDistrict/'+ id);
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
  //register hotel with Multiple
  registerhotel(form:FormType): Observable<any>{
    const formData = new FormData();
    //get Multiple files to API
    // for (let i = 0; i < images.length; i++) {
    //   formData.append('images', images[i]);
    // }
    
    // convert image to Base64 encoded
    
    const { hotelName, email, phone, username, password, contactName, decription,province, district, ward, street,  images } = form;
    console.log('form service',form)
    formData.append('image', images);

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