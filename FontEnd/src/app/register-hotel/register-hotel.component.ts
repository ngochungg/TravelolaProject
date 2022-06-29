import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { HttpClient } from '@angular/common/http';
import { FormGroup, FormControl, Validators} from '@angular/forms';
@Component({
  selector: 'app-register-hotel',
  templateUrl: './register-hotel.component.html',
  styleUrls: ['./register-hotel.component.css']
})
export class RegisterHotelComponent implements OnInit {
  imageSrc: string | undefined;



 
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
    images :null
  };

  isSuccessful = false;
  isSignUpFailed = false;
  errorMessage = '';
  provin: any[] = [];
  user: any[] = [];
  addUser:any = [];
  dis: any[] = [];
  diss: any[] = [];
  dist: any[] = [];
  ward: any[] = [];
  d:any[] = [];
  constructor(private authService: AuthService,private http: HttpClient) { }
  ngOnInit(): void {
    this.authService.getProvince().subscribe({
      next: data => {
        this.provin = data;
        console.log(this.provin);
      }
    });
  }
  
  onSubmit(): void {
   
    this.authService.registerhotel(this.form).subscribe({
      next: data => {
          
          this.addUser = data;
          console.log(this.addUser);
          this.isSuccessful = true;
          this.isSignUpFailed = false;
        }

    });
  }

  



  public district: string[] = [];
  public disI:string[] = [];
  // public war: string[] = [];
  public changeDistrict(event: any): void {
    //get district to province id
    const name = event.target.value;
    this.form.province=name
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
    this.form.district = name
   
    this.authService.getWards(name).subscribe({
      next: data => {
        this.d = data;
      }
    });

  }
}
 