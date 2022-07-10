import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';

@Component({
  selector: 'app-booking',
  templateUrl: './booking.component.html',
  styleUrls: ['./booking.component.css']
})
export class BookingComponent implements OnInit {

  constructor(private authService: AuthService,private token: TokenStorageService) { }
  user:any;
  dtUser :any[]=[];
  ngOnInit(): void {
    this.user =this.token.getUser();

    this.authService.getBooking(this.user.id).subscribe({
      next:data=>{
        this.dtUser=data;
        console.log(data)
      }
    });
  }

}
