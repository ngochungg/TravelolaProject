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

  constructor(private authService: AuthService, private http: HttpClient, private token: TokenStorageService, private userService: UserService) { }
  roomHotel: any;
  rooms: any;
  errorMessage = '';
  id: any;
  selectedFile!: File;

  ngOnInit(): void {
    this.roomHotel = this.token.getUser();
    console.log(this.roomHotel)

    this.userService.showAllHotel().subscribe({
      next: data => {
        console.log('data', data)
        for (let i = 0; i < data.length; i++) {
          if (data[i].phone === this.roomHotel.phone) {
            this.id = data[i].id
          }
        }
        this.userService.allRooms(this.id).subscribe({
          next: data => {
            this.rooms = data;
            console.log('allrooms', this.rooms);

          }

        })
        console.log('idHotel', this.id)
        // console.log(data)
        // console.log('id', this.roomHotel.id);

      },
      error: err => {
        this.errorMessage = err.error.message;
      }
    });





  }


}
