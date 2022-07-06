import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';

import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';

@Component({
  selector: 'app-update-avata',
  templateUrl: './update-avata.component.html',
  styleUrls: ['./update-avata.component.css']
})
export class UpdateAvataComponent implements OnInit {
  currentUser: any;
  constructor(private token: TokenStorageService,private authService: AuthService, private tokenStorage: TokenStorageService,
private http: HttpClient) { }
  selectedFile!: File;
  ngOnInit(): void {
    this.currentUser = this.token.getUser();

  }
  onFileSelected(event: any){
    this.selectedFile=<File>event.target.files[0];
  }
  onUpdataIMG(){
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata =new FormData();
    filedata.append('images', this.selectedFile, this.selectedFile.name);
    this.http.post('http://localhost:8080/api/auth/uploadImage/'+this.currentUser.id, filedata, {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});
  }
 
}
