import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { UserService } from '../_services/user.service';

import { HttpClient, HttpHeaders } from '@angular/common/http';



interface hol {
  id: string;
  hotelName: string;
  phone: string;
  description: string;
  numberOfRoom: number;
  wifi: boolean;
  freeBreakfast: boolean;
  freeParking: boolean;
  petsAllowed: boolean;
  hotTub: boolean;
  swimmingPool: boolean;
  gym: boolean;
  location: any[];

}
@Component({
  selector: 'app-city',
  templateUrl: './city.component.html',
  styleUrls: ['./city.component.css']
})
export class CityComponent implements OnInit {
  in4City: any[] = [];
  public id!: string;

  city: any;
  constructor(private userService: UserService, private http: HttpClient) { }
  public province = '';
  ngOnInit(): void {
    let headers = new HttpHeaders();
    this.userService.showAllHotel().subscribe({
      next: data => {
        this.city = data;
        for (let i = 0; i < this.city.length; i++) {
          const citys = this.city[i]
          this.in4City.push(citys)
          console.log('in4City', this.in4City)
        }
        this.city
      }

    });
  }


}
