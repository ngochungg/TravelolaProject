import { Component, OnInit } from '@angular/core';
import { UserService } from '../_services/user.service';
import { AuthService } from '../_services/auth.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';




@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})


export class HomeComponent implements OnInit {
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
      }

    });
  }


  // Location(event:any):void{
  //   const ev =event.target.value
  //   console.log('ev',ev)
  // }
}