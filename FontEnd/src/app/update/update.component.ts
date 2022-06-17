import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { Router } from '@angular/router';
import { FacebookLoginProvider, GoogleLoginProvider, SocialAuthService, SocialUser } from '@abacritt/angularx-social-login';
 
@Component({
  selector: 'app-update',
  templateUrl: './update.component.html',
  styleUrls: ['./update.component.css']
})
export class UpdateComponent implements OnInit {
  currentUser: any;

  form: any = {
    
    firstName: null,
    lastName: null,
    email:null,
    phone: null,
  };
  isSuccessful = false;

  errorMessage = '';
  constructor(private token: TokenStorageService,private authService: AuthService, private tokenStorage: TokenStorageService, 
     private router: Router) { }

  ngOnInit(): void {

  }
  onUpdate(): void {
    this.currentUser = this.token.getUser();
    const {  firstName, lastName, email,  phone} = this.form;
    this.authService.update(firstName,lastName,email,phone).subscribe({
      next: data => {
        console.log(data);
        this.router.navigate(['/profile'])
        .then(() => {
          this.reloadPage();
        });
      },
      error: err => {
        this.errorMessage = err.error.message;
        console.log(err);

      }
    });
  }
  reloadPage(): void {
    window.location.reload();
  }
  // reload(): void{
  //   this.authService.reloadPro().subscribe({
  //     next: data => {
  //       // console.log(data);
  //       this.viewProfile = data;
  //       console.log(this.viewProfile);
  //       // this.reloadPage();
  //     },
  //     error: err => {
  //       this.errorMessage = err.error.message;
  //     }
  //   });

  //   }
}
