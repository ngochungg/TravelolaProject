import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';

import { Router } from '@angular/router';
@Component({
  selector: 'app-register-hotel',
  templateUrl: './register-hotel.component.html',
  styleUrls: ['./register-hotel.component.css']
})
export class RegisterHotelComponent implements OnInit {
  imageSrc: string | undefined;
  isSuccessful = false;
  isSignUpFailed = false;
  errorMessage = '';
  provin: any[] = [];
  user: any[] = [];
  addUser: any = [];
  dis: any[] = [];
  diss: any[] = [];
  dist: any[] = [];
  d: any[] = [];

  constructor(private authService: AuthService, private http: HttpClient,private router: Router) { }
  selectedFile!: File;
  ngOnInit(): void {
    this.authService.getProvince().subscribe({
      next: data => {
        this.provin = data;
        console.log(this.provin);
      }
    });
  }

  onSubmit(): void {
   
  }

  onFileSelected(event: any) {
    this.selectedFile = <File>event.target.files[0];
    console.log('event', this.selectedFile)
  }
  // public urlIMG: string[] = [];
  public hotelName ='';
  public email ='';
  public phone ='';
  public username ='';
  public password ='';
  public contactName ='';
  public description ='';
  public street ='';
  public ward ='';
  public district ='';
  public province ='';
  public images ='';
  onUpload(){
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata =new FormData();
    filedata.append('images', this.selectedFile, this.selectedFile.name);
    filedata.append('hotelName', this.hotelName);
    filedata.append('email',  this.email);
    filedata.append('phone',  this.phone);
    filedata.append('username',  this.username); 
    filedata.append('password',  this.password);
    filedata.append('contactName',  this.contactName);
    filedata.append('description',  this.description);
    filedata.append('street', this.street);
    filedata.append('ward',  this.ward);
    filedata.append('district',  this.district);
    filedata.append('province',  this.province);
    // console.log('form',)

    this.http.post('http://localhost:8080/api/hotel/addHotel', filedata, {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});
    this.router.navigate(['/login'])
    .then(() => {
      this.reloadPage();
    });
  }



  
  public disI: string[] = [];
  // public war: string[] = [];
  public changeDistrict(event: any): void {
    //get district to province id
    const name = event.target.value;
    this.province = name
    this.authService.getDistrict(name).subscribe({
      next: data => {
        this.dis = data;
        console.log('district', this.dis);
      }
    });
  }

  public changeWard(event: any): void {
    //get ward to district id
    const name = event.target.value;
    this.district = name

    this.authService.getWards(name).subscribe({
      next: data => {
        this.d = data;
      }
    });

  }
  reloadPage(){
    window.location.reload();
  }
}
