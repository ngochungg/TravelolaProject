
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';

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
  _usersID:any[]=[];
  ngOnInit(): void {
    this.user=this.token.getUser();
    console.log('user',this.user);
    this.userService.showAllHotel().subscribe({
      next: (data) => {
        console.log('data',data);
        for (let i = 0; i < data.length; i++) {
          if (data[i].account.username= this.user.username) {
            this.id = data[i].account.id;
           
            console.log('users', this.id);
 
            this.userService.showHotelBookingByHotelId(this.id).subscribe({
              next: (data) => {
                console.log('data', data);
                this.usersID=data;
                console.log('data', this.usersID);

                this._usersID=[...this.usersID]
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
      this.http.put('http://localhost:8080/api/hotel/setHotelBookingStatusTrue/'+ev,{headers: headers, responseType: 'text'}  ).subscribe(res =>{console.log(res)});
      this.reloadPage();
    }

    public searchKeyword:any;
    searchUser(even:any){
      this.searchKeyword = even.target.value;
   
      if (this.searchKeyword === null || this.searchKeyword === '') {
        this.usersID = this._usersID;
      } else {
        if (this.searchKeyword.length > 0) {
          console.log(this.searchKeyword);
          const userFilted = this._usersID.filter((use) =>
           use.user.phone.includes(this.searchKeyword != null ? this.searchKeyword : '')
          );
          this.usersID = userFilted;
        }
      }
    }
    report(){

    }
    reloadPage(): void {
      window.location.reload();
    }
}
