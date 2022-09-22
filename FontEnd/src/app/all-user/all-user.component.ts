import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { Router } from '@angular/router';
import { Container } from '@angular/compiler/src/i18n/i18n_ast';

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
  selector: 'app-all-user',
  templateUrl: './all-user.component.html',
  styleUrls: ['./all-user.component.css'],
})
export class AllUserComponent implements OnInit {
  [x: string]: any;
  currentUser: any;

  //array of users
  user: any[] = [];
  _user: User[] = [];
  users: User[] = [];
  search: any[] = [];
  userID: any[] = [];
  searchKeyword: string | null = '';

  
  constructor(
    private token: TokenStorageService,
    private authService: AuthService,
    private tokenStorage: TokenStorageService,
    private router: Router
  ) { }

  ngOnInit(): void {
    this.authService.getAllUsers().subscribe({
      next: (data) => {
        this.users = data;
        for (let i = 0; i < this.users.length; i++) {
          let role = this.users[i].roles[0].name;
          if (role == "ROLE_USER") {
            this.user.push(this.users[i]);
          }
        }
        console.log('role', this.user)
        this._user = [...this.user];
      },
      error: (err) => {
        
        this.router.navigate(['/home'])
        .then(() => {
          this.reloadPage();
        });
      
      },
    });
  }


  UnLock(use: User): void {

    this.authService.unlockUser(use.id).subscribe({
      next: (data) => {
        this.reloadPage();
      }
    });
  }

  Lock(use: User): void {
    this.authService.lockUser(use.id).subscribe({
      next: (data) => {
        this.reloadPage();
      }
    });
  }



  searchUser(event: any) {
    this.searchKeyword = event.target.value;


    // console.log(this.users);
    if (this.searchKeyword === null || this.searchKeyword === '') {
      this.user = this._user;
    } else {
      if (this.searchKeyword.length > 0) {
        console.log(this.searchKeyword);
        const userFilted = this._user.filter((use) =>
          use.username.toLowerCase().includes(this.searchKeyword != null ? this.searchKeyword.toLowerCase() : '')
        );
        this.user = userFilted;
      }
    }
  }
  reloadPage(): void {
    window.location.reload();
  }
}
