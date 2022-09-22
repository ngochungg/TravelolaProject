
import { HttpHeaders } from '@angular/common/http';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';

@Component({
  selector: 'app-up-image',
  templateUrl: './up-image.component.html',
  styleUrls: ['./up-image.component.css']
})
export class UpImageComponent implements OnInit {
  img :any;
  
  constructor(private token: TokenStorageService,private authService: AuthService, private tokenStorage: TokenStorageService,private http: HttpClient,private router:Router ) {}
  selectedFile!: File;
  currentUser: any;
  ngOnInit(): void {
    this.currentUser = this.token.getUser();
    console.log('currentUser', this.currentUser);
  }

  onFileSelected(event: any){
    this.selectedFile=<File>event.target.files[0];
    this.img =this.selectedFile.name;
    console.log(this.selectedFile.name)
  }

  onUpload(){
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata =new FormData();
    filedata.append('file', this.selectedFile, this.selectedFile.name);
    console.log('filedata', this.selectedFile, this.selectedFile.name)
    this.router.navigate(['/profile'])
    this.http.post('http://localhost:8080/api/auth/uploadImage/'+this.currentUser.id, filedata, {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});
  }
}
