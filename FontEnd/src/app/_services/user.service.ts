import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

const API_URL = 'http://localhost:8080/api/test/';
const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};
@Injectable({
  providedIn: 'root'
})
export class UserService {
  constructor(private http: HttpClient) { }

  getPublicContent(): Observable<any> {
    return this.http.get(API_URL + 'all', { responseType: 'text' });
  }

  getUserBoard(): Observable<any> {
    return this.http.get(API_URL + 'user', { responseType: 'text' });
  }

  getModeratorBoard(): Observable<any> {
    return this.http.get(API_URL + 'mod', { responseType: 'text' });
  }

  getAdminBoard(): Observable<any> {
    return this.http.get(API_URL + 'admin', { responseType: 'text' });
  }
   showAllHotel(): Observable<any> {
    return this.http.get('http://localhost:8080/api/hotel/' + 'getAllHotel');
  }
  find4ProvinceHaveMostHotel(): Observable<any> {
    return this.http.get('http://localhost:8080/api/hotel/find4ProvinceHaveMostHotel');
  }
  allHotel(): Observable<any> {
    return this.http.get('http://localhost:8080/api/hotel/getAllHotel');
  }
  allRooms(id : string): Observable<any> {

    return this.http.get('http://localhost:8080/api/hotel/getRoom/' +id);
  }
  getAllRoom(): Observable<any> {
    return this.http.get('http://localhost:8080/api/hotel/getAllRoom' );
  }
  hotelService(id :string): Observable<any> {
    return this.http.post('http://localhost:8080/api/hotel/addServices/'+id, {
   

    });
    
  }
  hotelBooking(checkInDate: string, checkOutDate: string, numOfGuest: number, paymentMethod: string, totalPrice: number,roomId:number,userId: number): Observable<any> {
    return this.http.post('http://localhost:8080/api/hotel/hotelBooking', {
    checkInDate,
    checkOutDate,
    numOfGuest,
    paymentMethod,
    totalPrice,
    roomId,
    userId
   
    },httpOptions);
  }

  showHotelBookingByHotelId(id :string): Observable<any> {
    return this.http.get('http://localhost:8080/api/hotel/showHotelBookingByHotelId/'+id );
  }

  confirmBooking(id: string): Observable<any> {
    return this.http.post('http://localhost:8080/api/hotel/confirmedHotelBooking/' + id,{});
  }

  refuseBooking(id: string): Observable<any> {
    return this.http.post('http://localhost:8080/api/hotel/refuseHotelBooking/' + id,{});
  }
  getAllBookingRetiredTrue(): Observable<any> {
    return this.http.get('http://localhost:8080/api/hotel/getAllBookingRetiredTrue');
  }

}
