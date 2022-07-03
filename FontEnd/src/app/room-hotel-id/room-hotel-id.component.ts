import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
@Component({
  selector: 'app-room-hotel-id',
  templateUrl: './room-hotel-id.component.html',
  styleUrls: ['./room-hotel-id.component.css']
})
export class RoomHotelIDComponent implements OnInit {

  constructor(private authService: AuthService, private http: HttpClient, private token: TokenStorageService,private userService: UserService) { }
  roomHotel: any;
  rooms:any;
  errorMessage = '';
  
  selectedFile!: File;

  ngOnInit(): void {
    this.roomHotel = this.token.getUser();
    this.authService.reloadPro().subscribe({
      next: data => {
        // console.log(data);
        this.roomHotel.id = data.id;
        console.log('id', this.roomHotel.id);

      },
      error: err => {
        this.errorMessage = err.error.message;
      }
    });

   
    this.userService.allRooms(this.roomHotel.id ).subscribe({
      next: data => {
        this.rooms = data;
        console.log('allrooms', this.rooms);
      }

    })


  }


}
