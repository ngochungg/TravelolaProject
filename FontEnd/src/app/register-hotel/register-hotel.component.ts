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
    email: null,
    phone: null,
    username: null,
    password: null,
    contactName: null,
    decription: null,
    street: null,
    ward: null,
    district: null,
    province: null,
    imageUrl: null
  };

  isSuccessful = false;
  isSignUpFailed = false;
  errorMessage = '';
  provin: any[] = [];
  user: any[] = [];
  dis: any[] = [];
  diss: any[] = [];
  dist: any[] = [];
  ward: any[] = [];
  d:any[] = [];
  constructor(private authService: AuthService) { }
  ngOnInit(): void {
    this.authService.getProvince().subscribe({
      next: data => {
        this.provin = data;
        console.log(this.provin);
      }
    });
  }
  onSubmit(): void {
    // const { hotelName, email, phone, username, password, contactName, decription,province, district, ward, street,  imageUrl } = this.form;
    // this.authService.registerhotel(hotelName, email, phone, username, password, contactName, decription,province, district, ward, street,  imageUrl).subscribe({
    //   next: data => {

    //     this.user = data;
    //     console.log(this.user);
    //     this.isSuccessful = true;
    //     this.isSignUpFailed = false;
    //   },
    //   error: err => {
    //     this.errorMessage = err.error.message;
    //     this.isSignUpFailed = true;
    //   }
    // });
    //call api to register hotel have Multiple files images
    const { hotelName, email, phone, username, password, contactName, decription,province, district, ward, street,  images } = this.form;
    this.authService.registerhotel(hotelName, email, phone, username, password, contactName, decription,province, district, ward, street,  images).subscribe({
      next: data => {
          
          this.user = data;
          console.log(this.user);
          this.isSuccessful = true;
          this.isSignUpFailed = false;
        }
      ,
      error: err => {
        this.errorMessage = err.error.message;
        this.isSignUpFailed = true;
      }
    });
  }

  public district: string[] = [];
  public disI:string[] = [];
  // public war: string[] = [];



  public changeDistrict(event: any): void {
    //get district to province id
    const name = event.target.value;
    console.log('event', name);
    this.authService.getDistrict(name).subscribe({
      next: data => {
        this.dis = data;
        console.log('district',this.dis);
      }
    });
  }

  public changeWard(event: any): void {
    //get ward to district id
    const name = event.target.value;
    console.log('event', name);
    this.authService.getWards(name).subscribe({
      next: data => {
        this.d = data;
        console.log('ward',this.d);
      }
    });

  }
}
 