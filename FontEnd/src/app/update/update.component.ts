import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { Router } from '@angular/router';
import { environment } from 'src/environments/environment';
import { HttpClient, HttpClientModule, HttpHeaders } from '@angular/common/http';

@Component({
  selector: 'app-update',
  templateUrl: './update.component.html',
  styleUrls: ['./update.component.css']
})
export class UpdateComponent implements OnInit {
  updateInformation = false;
  updateAvatar = false;
  changePassword=false;
  chooseEvent=true;
  currentUser: any;
  imageUrl :any;
  img :any;
  form: any = {

    firstName: null,
    lastName: null,
    email:null,
    phone: null,
    image:File
  };
 
  isSuccessful = false;

  errorMessage = '';
  timeStamp: any;
  selectedFile!: File;
  
  constructor(private token: TokenStorageService,private authService: AuthService, private tokenStorage: TokenStorageService,
     private router: Router,private http: HttpClient) { }
     
  ngOnInit(): void {
    this.currentUser = this.token.getUser();
    console.log(this.currentUser)
 
  }
  onUpdate(): void {
    this.currentUser = this.token.getUser();
    const {  firstName, lastName, email,  phone} = this.form;
    this.authService.update(firstName,lastName,email,phone).subscribe({
      next: data => {
        console.log(data);
        this.router.navigate(['/profile'])
        .then(() => {
          this.reloadPage();
        });
      },
      error: err => {
        // this.errorMessage = err.error.message;
        console.log(err);

      }
    });
    
  }

  reloadPage(): void {
    window.location.reload();
  }
  onUpdateIMG(){
    this.currentUser = this.token.getUser();
    const { imageUrl} = this.form;
    this.authService.updateIMG(imageUrl).subscribe({
      next: data => {
        console.log(data);
        this.router.navigate(['/update'])
        .then(() => {
          this.reloadPage();
        });
      },
      error: err => {
        this.errorMessage = err.error.message;
        console.log(err);

      }
    });
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
  information(){
    this.updateInformation = true;
    this.updateAvatar = false;
    this.changePassword = false;
    this.chooseEvent=false;
  }

  avatar(){
    this.updateInformation = false;
    this.updateAvatar = true;
    this.changePassword = false;
    this.chooseEvent=false;
  }

  password(){
    this.updateInformation = false;
    this.updateAvatar = false;
    this.changePassword = true;
    this.chooseEvent=false;
  }

  pass:any={
    oldpass:'',
    newpass:'',
  }

  changPassword(){
   

    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata =new FormData();
    filedata.append('oldPassword', this.pass.oldpass);
    filedata.append('newPassword', this.pass.newpass);

    this.http.post('http://localhost:8080/api/auth/updatePassword/'+this.currentUser.id,filedata,{headers: headers, responseType: 'text'}).subscribe(res =>{console.log(res)});
  }

 
}
