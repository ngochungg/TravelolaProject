import { Component, OnInit } from '@angular/core';

import { HttpHeaders } from '@angular/common/http';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
@Component({
  selector: 'app-forgot-password',
  templateUrl: './forgot-password.component.html',
  styleUrls: ['./forgot-password.component.css']
})
export class ForgotPasswordComponent implements OnInit {

  constructor(private http: HttpClient,private router:Router ) {}
 

  ngOnInit(): void {

  }
  
  public email='';
  sentMail(){
    console.log('em',this.email)
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    this.http.post('http://localhost:8080/api/auth/forgotPassword/'+this.email, {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});
  }

}
