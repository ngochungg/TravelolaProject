import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
@Component({
  selector: 'app-register-hotel',
  templateUrl: './register-hotel.component.html',
  styleUrls: ['./register-hotel.component.css']
})
export class RegisterHotelComponent implements OnInit {
  form: any = {
    hotelName: null,
    email:null,
    phone:null,
    username:null,
    password: null,
    contactName:null,
    decription:null,
    street:null,
    ward:null,
    district:null,
    province:null,
    imageUrl: null
  };
  isSuccessful = false;
  isSignUpFailed = false;
  errorMessage = '';
  user:string[] = [];
  constructor(private authService: AuthService) { }
  ngOnInit(): void {
  }
  onSubmit(): void {
    const { hotelName, email,phone, username, password, contactName, decription, street,ward,district,province, imageUrl} = this.form;
    this.authService.registerhotel( hotelName, email,phone, username, password, contactName, decription, street,ward,district,province, imageUrl).subscribe({
      next: data => {
       
        this.user=data;
        console.log(this.user);
        this.isSuccessful = true;
        this.isSignUpFailed = false;
      },
      error: err => {
        this.errorMessage = err.error.message;
        this.isSignUpFailed = true;
      }
    });
  }
}
