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


        // console.log(this.dist.length);
      // for(let i = 0; i < this.dist.length; i++) {
      //   if(this.dist[i].province[i].name=== this.provin[0].name){
      //     const d= this.dist[i].districts;

      //     console.log('day la d',d)
      //   }
       
      // }
      
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
    const { hotelName, email, phone, username, password, contactName, decription, street, ward, district, province, imageUrl } = this.form;
    this.authService.registerhotel(hotelName, email, phone, username, password, contactName, decription, street, ward, district, province, imageUrl).subscribe({
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

    // thu xem provin co ton tai ko
    // console.log('provin',this.provin);

    const search = this.provin.filter(a => a.name === name);
    // console.log('search', search[0].districts);
    console.log('search', search);
    if (search && search.length > 0) {
      for (let i = 0; i < search[0].districts.length; i++) {

        this.district = search[0].districts[i].name;
       

        console.log('district', this.district);
        this.dis.push(this.district)
        
      }
      // this.disI.push(this.district[0]);
      // console.log('disI', this.disI); 
    }
    console.log('dis',this.dis)
  }

}
    
      // this.district=this.provin.find(data=>data.name === name)?.districts  || [];
    // console.log(this.district);
  // public changeWard(event: any): void {
  //   //lay ra ten tinh/thanh pho dc chon
  //   const name = event.target.value;
  //   console.log('event', name);

  //   // thu xem provin co ton tai ko
  //   // console.log('provin',this.provin);

  //   const search = this.dist.filter(b => b.name === name);
  //   console.log('search', search);
  //   if (search && search.length > 0) {
  //     this.war = search[0].wards;
  //     console.log('districts', this.war);
  //   }   
  // this.district=this.provin.find(data=>data.name === name)?.districts  || [];
  // console.log(this.district);
  // }