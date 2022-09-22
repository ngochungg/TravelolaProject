import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  currentUser: any;
  viewProfile: any;
  errorMessage = '';
  constructor(private token: TokenStorageService,private authService: AuthService, private tokenStorage: TokenStorageService, 
    private router: Router ) { }

  ngOnInit(): void {
    this.currentUser = this.token.getUser();
    this.authService.reloadPro().subscribe({
      next: data => {
        // console.log(data);
        this.currentUser.firstName = data.firstName;
        this.currentUser.lastName = data.lastName;
        this.currentUser.email = data.email;
        this.currentUser.phone = data.phone;
        data.imageUrl=this.currentUser.imageUrl
        console.log('imageUrl',this.currentUser.imageUrl);
        console.log(this.currentUser);
        console.log('data',data);
        // this.reloadPage();
      },
      error: err => {
        this.errorMessage = err.error.message;
      }
    });

    if(this.currentUser.imageUrl == null){
     
      this.currentUser.imageUrl = 'http://localhost:8080/api/auth/' + 'getImage/' + 'default.png';

    }
    else{
      this.currentUser.imageUrl = 'http://localhost:8080/api/auth/' + 'getImage/' + this.currentUser.imageUrl;
    }
  }
 
  reloadPage(): void {
    window.location.reload();
  }
  reload(): void{
    this.authService.reloadPro().subscribe({
      next: data => {
        // console.log(data);
        this.viewProfile = data;
        console.log(this.viewProfile);
        // this.reloadPage();
      },
      error: err => {
        this.errorMessage = err.error.message;
      }
    });

    }
}
