
import { HttpHeaders } from '@angular/common/http';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-up-image',
  templateUrl: './up-image.component.html',
  styleUrls: ['./up-image.component.css']
})
export class UpImageComponent implements OnInit {
  
  constructor(private http: HttpClient, ) {}
  selectedFile!: File;
  ngOnInit(): void {
  }

  onFileSelected(event: any){
    this.selectedFile=<File>event.target.files[0];
  }
  public email ='';
  public username ='';
  public phone ='';
  onUpload(){
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata =new FormData();
    filedata.append('images', this.selectedFile, this.selectedFile.name);
    filedata.append('hotelName', 'aloola');
    filedata.append('email', this.email);
    filedata.append('phone', this.phone);
    filedata.append('username', this.username); 
    filedata.append('password', '12345678');
    filedata.append('contactName', 'meo3ss2422vn');
    filedata.append('decription', 'aloalo123456');
    filedata.append('street', '111 - le loi 1');
    filedata.append('ward', '1');
    filedata.append('district', '1');
    filedata.append('province', '1');

    this.http.post('http://localhost:8080/api/hotel/addHotel', filedata, {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});
  }
}
