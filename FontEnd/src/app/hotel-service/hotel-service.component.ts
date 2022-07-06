import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
@Component({
  selector: 'app-hotel-service',
  templateUrl: './hotel-service.component.html',
  styleUrls: ['./hotel-service.component.css']
})
export class HotelServiceComponent implements OnInit {

  constructor(private authService: AuthService, private http: HttpClient, private token: TokenStorageService, private userService: UserService) { }
  hotel: any;
  rooms: any;
  room: any;
  service: any;
  errorMessage = '';
  id: any;
  form: any = {

    paymentAtTheHotel: null,
    wifi: null,
    freeBreakfast: null,
    freeParking: null,
    petsAllowed: null,
    hotTub: null,
    swimmingPool: null,
    gym: null
  };

  public paymentAtTheHotel = 'true';
  public wifi = 'true';
  public phone = 'true';
  public freeBreakfast = 'true';
  public freeParking = 'true';
  public petsAllowed = 'true';
  public hotTub = 'true';
  public swimmingPool = 'true';
  public gym = 'true';
  ngOnInit(): void {
    this.hotel = this.token.getUser();
    this.userService.showAllHotel().subscribe({
      next: data => {
        this.rooms = data;
       
        console.log('allrooms', this.rooms);
        for (let i = 0; i < data.length; i++) {
          if (data[i].phone === this.hotel.phone) {
            this.id = data[i].id
       
          }
        }

        console.log('idHotel', this.id)
      },
      error: err => {
        this.errorMessage = err.error.message;
      }
    });

  }

  change(event:any):void{
    const ev =event.target.value;
    console.log('ev', ev)
    
    if(ev == true)
    {
      
    }
  }
}






