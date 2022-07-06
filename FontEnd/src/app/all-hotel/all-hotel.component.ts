import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { Router } from '@angular/router';
import { UserService } from '../_services/user.service';

interface User {
  id: string;
  username: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  roles: any[];
}
@Component({
  selector: 'app-all-hotel',
  templateUrl: './all-hotel.component.html',
  styleUrls: ['./all-hotel.component.css']
})
export class AllHotelComponent implements OnInit {
  [x: string]: any;
  currentUser: any;
  user: any[] = [];
  _user: User[] = [];
  errorMessage = '';
  users: any[] = [];


  constructor(private token: TokenStorageService, private authService: AuthService, private tokenStorage: TokenStorageService,
    private router: Router, private userService: UserService) { }
  hotel: any;
  id: any;
  phone:any;
  ngOnInit(): void {

    this.userService.showAllHotel().subscribe({
      next: data => {
        this.hotel = data;
        console.log('hotel',  this.hotel)
        for (let i = 0; i < data.length; i++) {
          if (data[i].phone === this.hotel.phone) {
            this.id = data[i].id
            this.phone =data[i].phone
          }
        }

        console.log('idHotel', this.id)
      },
      error: err => {
        this.errorMessage = err.error.message;
      }
    });

    
  }

  accept(user: any): void {
    this.authService.refuseHotel(user.id).subscribe({
      next: (data) => {
        this.reloadPage();
      }
    });
  }

  no(user: User): void {
    this.authService.confirmHotel(user.id).subscribe({
      next: (data) => {
        this.reloadPage();
      }
    });
  }

  UnLook(user: User): void {

    this.authService.unlockUser(user.id).subscribe({
      next: (data) => {
        this.reloadPage();
      }
    });
  }

  hotelID :any;
  Look(user: User): void {
    console.log('id',this.id)
    this.authService.lockUser(user.id).subscribe({
      next: (data) => {
        this.reloadPage();
      }
    });

    // this.authService.getAllUsers().subscribe({
    //   next: (data) => {
    //     this.users = data;
    //     console.log('users', this.users)
        
    //     for (let i = 0; i < this.users.length; i++) {
    //       if(this.phone== this.users[i].phone){
    //         this.hotelID=this.user[i].id;
    //       }
    //       console.log('lock/unlock:ID',this.hotelID)
    //     } 
    //   },
    //   error: (err) => {
    //     throw Error('Error');
    //   },
    // });

  
 
  }

  reloadPage(): void {
    
    window.location.reload();
  }
}
