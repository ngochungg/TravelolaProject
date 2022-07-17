import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';

@Component({
  selector: 'app-user-booking-history',
  templateUrl: './user-booking-history.component.html',
  styleUrls: ['./user-booking-history.component.css']
})
export class UserBookingHistoryComponent implements OnInit {
  gfg = 5; 
  sao = 0;
 
  constructor(private authService: AuthService,private token: TokenStorageService,private userService: UserService,private http: HttpClient,private router: Router) { }
  user:any;
  dtUser :any[]=[];
  id:any;
  usersID:any;
  done=false;
  ngOnInit(): void {
    this.user =this.token.getUser();

    this.authService.getBooking(this.user.id).subscribe({
      next:data=>{
        this.dtUser=data;
        console.log(data)
        
      }
    });

    
  }
  ev:any;
  openFeedback(event:any){
    this.ev=event.target.value;
    console.log(this.ev)
    this.done=!this.done;

  }
  form: any = {
    feedback: null,
    rating:null,
    hotel_booking_id: null,
  };
  sendFeedback(event:any){
    const { feedback, rating, hotel_booking_id} = this.form;
    this.authService.feedback(feedback, this.sao,this.ev).subscribe({
      next: data => {
        console.log(data);
 
      }
    });

  }
  reloadPage(){
    window.location.reload();
  }
}
