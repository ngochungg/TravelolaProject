import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { UserService } from '../_services/user.service';
interface hol{
  id : string;
  hotelName : string;
  phone :string;
  description: string;
  numberOfRoom : number;
  wifi : boolean;
  freeBreakfast : boolean;
  freeParking : boolean;
  petsAllowed: boolean;
  hotTub : boolean;
  swimmingPool: boolean;
  gym : boolean;
  location :any[];

}
@Component({
  selector: 'app-city',
  templateUrl: './city.component.html',
  styleUrls: ['./city.component.css']
})
export class CityComponent implements OnInit {

  constructor(private authService: AuthService,private userService: UserService) { }

  hotel: any[] = [];
  hotels: hol[] = [];
  public hol:hol[] = [];
  ngOnInit(): void {

    this.userService.showAllHotel().subscribe({
      next:data => {
        this.hotel = data;
        // console.log('hotel',this.hotel)
        for (let i = 0; i < this.hotel.length; i++) {
          const hotels =this.hotel[i];
          console.log('hotels',hotels);
          this.hol.push(hotels);
        }
      
        console.log('hol',this.hol)

      }
    });
  }

}
