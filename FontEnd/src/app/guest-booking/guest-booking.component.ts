
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
interface room {
  id:string,
  retired:false,

}
@Component({
  selector: 'app-guest-booking',
  templateUrl: './guest-booking.component.html',
  styleUrls: ['./guest-booking.component.css']
})
export class GuestBookingComponent implements OnInit {

  constructor(private token: TokenStorageService,private userService: UserService, private http: HttpClient,private router: Router,private authService: AuthService) { }
  user:any;
  id:any;
  usersID:any;
  ngOnInit(): void {
    this.user=this.token.getUser();
    console.log('user',this.user);
    this.userService.showAllHotel().subscribe({
      next: (data) => {
        for (let i = 0; i < data.length; i++) {
          if (data[i].phone == this.user.phone) {
            this.id = data[i].account.id;
           
            console.log('users', this.id);
 
            this.userService.showHotelBookingByHotelId(this.id).subscribe({
              next: (data) => {
                this.usersID=data;
                console.log('data', this.usersID);
              }
            });
          }
        }

      },
      error: (err) => {
        
       
      
      },
      
    });
    
    }

    confirm(event :any){
   
      const ev=event.target.value;
      // const index = this.usersID.findIndex((usersID: { id: string; }) => usersID.id === ev);
      // this.usersID[index] ={...this.usersID[index],status:true}
      let headers = new HttpHeaders();
      headers.append('Content-Type', 'multipart/form-data');
      this.http.put('http://localhost:8080/api/hotel/confirmedHotelBooking/'+ev,{headers: headers, responseType: 'text'}  ).subscribe(res =>{console.log(res)});
      this.reloadPage();
    }
   
    
    refuse(event:any){
      const ev = event.target.value;  
      console.log('ev',ev)
      let headers = new HttpHeaders();
      headers.append('Content-Type', 'multipart/form-data');
      this.http.put('http://localhost:8080/api/hotel/refuseHotelBooking/'+ev,{headers: headers, responseType: 'text'}  ).subscribe(res =>{console.log(res)});
      this.reloadPage();
    }
    status=false;
    done(event:any){
      const ev = event.target.value;  
      console.log('ev',ev)
      let headers = new HttpHeaders();
      
      headers.append('Content-Type', 'multipart/form-data');
      this.http.get('http://localhost:8080/api/hotel/confirmHotelBookingStatus/'+ev,{headers: headers, responseType: 'text'}  ).subscribe(res =>{console.log(res)});
      this.status=!this.status;
    }
    report(){

    }
    reloadPage(): void {
      window.location.reload();
    }
}