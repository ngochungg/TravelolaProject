import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { Router } from '@angular/router';


@Component({
  selector: 'app-all-hotel',
  templateUrl: './all-hotel.component.html',
  styleUrls: ['./all-hotel.component.css']
})
export class AllHotelComponent implements OnInit {
  [x: string]: any;
  currentUser: any;

  errorMessage = '';
  users: any[] = [];


  constructor(private token: TokenStorageService, private authService: AuthService, private tokenStorage: TokenStorageService,
    private router: Router) { }

  ngOnInit(): void {
    this.authService.getAllUsers().subscribe({
      next: data => {

        //get user roles ROLE_ADMIN in data and push to users array
        for (let i = 0; i < data.length; i++) {
          //get rolename from data
          let role = data[i].roles[0].name;
          if (role == "ROLE_MODERATOR") {
            this.users.push(data[i]);
          }
        }
        console.log(this.users);
      },
      error: err => {
        this.errorMessage = err.error.message;
        console.log(err);
      }
    });
  }
  

}