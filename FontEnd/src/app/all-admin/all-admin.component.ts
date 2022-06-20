import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { Router } from '@angular/router';


// export class User{
//   constructor(
//     public id: number,
//     public username :string,
//     public firstName :string,
//     public lastName :string,
//     public email  :string,
//     public phone : number
//   ){}
// }

@Component({
  selector: 'app-all-admin',
  templateUrl: './all-admin.component.html',
  styleUrls: ['./all-admin.component.css']
})

export class AllAdminComponent implements OnInit {
  [x: string]: any;
  currentUser: any;
  isAdmin = false;
  isSuccessful = false;
  account = 0;
  errorMessage = '';
  isLoggedIn = false;
  showAdminBoard = false;
  showModeratorBoard = false;
  timeStamp: any;
  //array of users
  users: any[] = [];


  constructor(private token: TokenStorageService, private authService: AuthService, private tokenStorage: TokenStorageService,
    private router: Router) { }

  ngOnInit(): void {
    this.authService.getAllUsers().subscribe({
      next: data => {
        console.log(data);
        this.users = data;
      },
      error: err => {
        this.errorMessage = err.error.message;
        console.log(err);
      }
    });
  }

  showAll(): void {

  }

  // reloadPage(): void {
  //   window.location.reload();
  // }

}
