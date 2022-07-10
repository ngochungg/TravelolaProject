import { Component, OnInit } from '@angular/core';
import { UserService } from '../_services/user.service';
import { AuthService } from '../_services/auth.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';




@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})


export class HomeComponent implements OnInit {
  in4City: any[] = [];
  public id!: string;

  city: any;
  constructor(private userService: UserService, private http: HttpClient,private router: Router) { }
  public province = '';
  ngOnInit(): void {
    this.userService.find4ProvinceHaveMostHotel().subscribe({
      next: data => {
        this.city = data;
        console.log('city',  this.city)
        
      }

    });
  }
  ev(event :any): void {
    const e =event.target.value;
    console.log('e',e)
    this.router.navigate(['/hotels', {name: JSON.stringify(e)}]);
  }

  // Location(event:any):void{
  //   const ev =event.target.value
  //   console.log('ev',ev)
  // }
}