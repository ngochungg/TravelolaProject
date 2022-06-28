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

    this.authService.getDistrict().subscribe({
      next: data => {
        this.dist = data;
        console.log(this.dist);
      }
    });

    this.authService.getWards().subscribe({

      next: data => {
        this.ward = data;
        // console.log(this.ward);
      }
    });
  }
  onSubmit(): void {
    const { hotelName, email, phone, username, password, contactName, decription,province, district, ward, street,  imageUrl } = this.form;
    this.authService.registerhotel(hotelName, email, phone, username, password, contactName, decription,province, district, ward, street,  imageUrl).subscribe({
      next: data => {

        this.user = data;
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

  public district: string[] = [];
  public disI:string[] = [];
  // public war: string[] = [];



  public changeDistrict(event: any): void {

    //lay ra ten tinh/thanh pho dc chon
    const name = event.target.value;
    console.log('event', name);

    const search = this.provin.filter(a => a.name === name);
    // console.log('search', search[0].districts);
    console.log('search', search);
    if (search && search.length > 0) {
      this.dis =[];
      for (let i = 0; i < search[0].districts.length; i++) {
        this.district = search[0].districts[i].name;
        // console.log('district', this.district);
        this.dis.push(this.district)  
      }  
    }
    console.log('dis',this.dis)
  }

  public changeWard(event: any): void {

    //lay ra ten quan/huyen   dc chon
    const name = event.target.value;
    console.log('event', name);

    //fill danh sach quan huyen dc tim thay co name = event
    const search = this.dist.filter(a => a.name === name);
    // console.log('search', search[0].districts);
    console.log('search', search);

    
    if (search && search.length > 0) {
      this.diss =[];
      for (let i = 0; i < search[0].wards.length; i++) {
        this.disI = search[0].wards[i].name;
        // console.log('district', this.district);
        this.diss.push(this.disI)  
      }  
    }
    console.log('diss',this.diss)
  }
}
 