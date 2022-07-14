import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
@Component({
  selector: 'app-user-booking-history',
  templateUrl: './user-booking-history.component.html',
  styleUrls: ['./user-booking-history.component.css']
})
export class UserBookingHistoryComponent implements OnInit {

  constructor(private authService: AuthService,private token: TokenStorageService,private userService: UserService) { }
  user:any;
  dtUser :any[]=[];
  id:any;
  usersID:any;
  ngOnInit(): void {
    this.user =this.token.getUser();

    this.authService.getBooking(this.user.id).subscribe({
      next:data=>{
        this.dtUser=data;
        console.log(data)
        
      }
    });

    
  }
//   toggleFullScreen() {
//     let elem =  document.body; 
//     let methodToBeInvoked = elem.requestFullscreen || 
//      elem.webkitRequestFullScreen || elem['mozRequestFullscreen'] || 
//      elem['msRequestFullscreen']; 
//     if(methodToBeInvoked) methodToBeInvoked.call(elem);

// }
}
