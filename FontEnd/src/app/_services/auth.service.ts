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

  constructor(private token: TokenStorageService, private http: HttpClient) { }

  getTest(): Observable<any> {
    return this.http.get(AUTH_API + 'test123', { responseType: 'text' });
  }

  login(username: string, password: string): Observable<any> {
    return this.http.post(AUTH_API + 'signin', {
      username,
      password
    }, httpOptions);
  }
  register(username: string, email: string, password: string, firstName: string, lastName: string, phone: string, imageUrl: string): Observable<any> {
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
  feedback( feedback: string,rating:number,hotel_booking_id:string): Observable<any> {

    return this.http.post('http://localhost:8080/api/auth/feedback', {
      feedback,
      rating,
      hotel_booking_id

  });
}

  reloadPro(): Observable<any> {
    this.currentUser = this.token.getUser();
    return this.http.get(AUTH_API + 'viewProfile/' + this.currentUser.id);
  }
  getAllUsers(): Observable<any> {
    return this.http.get(AUTH_API + 'getAllUser');
  }
  getWards(id: string): Observable<any> {
    return this.http.get(AUTH_API + 'getWard/' + id);
  }
  getDistrict(id: string): Observable<any> {
    return this.http.get(AUTH_API + 'getAllDistrict/' + id);
  }
  getProvince(): Observable<any> {
    return this.http.get(AUTH_API + 'getAllProvince');
  }

  allAdmin(): Observable<any> {

    return this.http.get(AUTH_API + 'viewAdmin/');
  }
  update(firstName: string, lastName: string, email: string, phone: string): Observable<any> {
    this.currentUser = this.token.getUser();
    return this.http.post(AUTH_API + 'updateUser/' + this.currentUser.id, {
      firstName,
      lastName,
      email,
      phone,
    }, httpOptions);
  }
  updateIMG(imageUrl: string): Observable<any> {
    this.currentUser = this.token.getUser();
    return this.http.post(AUTH_API + 'uploadImage/' + this.currentUser.id, {
      imageUrl,
    }, httpOptions);
  }
  loginFacebook(id: string, email: string, firstName: string, lastName: string, photoUrl: string): Observable<any> {
    return this.http.post(AUTH_API + 'loginFacebook', {
      id,
      email,
      firstName,
      lastName,
      photoUrl
    }, httpOptions);
  }
  loginGoogle(id: string, email: string, firstName: string, lastName: string, photoUrl: string): Observable<any> {
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
    return this.http.post(AUTH_API + 'lockUser/' + id, {
    }, httpOptions);
  }
  //unlock user
  unlockUser(id: string): Observable<any> {
    return this.http.post(AUTH_API + 'unlockUser/' + id, {
    }, httpOptions);
  }
  service(paymentAtTheHotel: boolean, wifi: boolean,freeBreakfast: boolean,freeParking: boolean,petsAllowed: boolean,hotTub: boolean,swimmingPool: boolean,gym:boolean): Observable<any> {
    this.currentUser = this.token.getUser();
    return this.http.post('http://localhost:8080/api/hotel/addServices/'+this.currentUser.id , {
      paymentAtTheHotel,
      wifi,
      freeBreakfast,
      freeParking,
      petsAllowed,
      hotTub,
      swimmingPool,
      gym
    },{responseType: 'text'});
  }
  confirmHotel(id: string): Observable<any> {
    return this.http.get('http://localhost:8080/api/hotel/confirmHotel/' + id,{});
  }
  refuseHotel(id: string): Observable<any> {
    return this.http.get('http://localhost:8080/api/hotel/refuseHotel/' + id, {
    });
  }
  getBooking(id: string): Observable<any> {
    return this.http.get('http://localhost:8080/api/auth/getBooking/' + id, {
    });
  }
  postAll(): Observable<any> {
    return this.http.get('http://localhost:8080/api/posts/all');
  } 
  getPost(id: string): Observable<any> {
    return this.http.get('http://localhost:8080/api/posts/' + id, {
    });
  }
  like(id: string): Observable<any> {
    return this.http.put('http://localhost:8080/api/posts/like/' + id, {
    });
  }
  
}