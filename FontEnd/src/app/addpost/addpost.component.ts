import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { TokenStorageService } from '../_services/token-storage.service';

@Component({
  selector: 'app-addpost',
  templateUrl: './addpost.component.html',
  styleUrls: ['./addpost.component.css']
})
export class AddpostComponent implements OnInit {
  selectedFile!: File;
  user:any;
  id:any;
  constructor( private http: HttpClient,private router: Router,private token: TokenStorageService) { }

  ngOnInit(): void {
    this.user=this.token.getUser();
    this.id = this.user.id;
  }
  onFileSelected(event: any) {
    this.selectedFile = <File>event.target.files[0];
    console.log('event', this.selectedFile)
  }
  // public urlIMG: string[] = [];
  public title ='';
  public description ='';
  public content ='';
  public userId ='';
  public imageUrl ='';
  onUpload(){
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata =new FormData();
    filedata.append('imageUrl', this.selectedFile, this.selectedFile.name);
    filedata.append('title', this.title);
    filedata.append('description',  this.description);
    filedata.append('content',  this.content);
    filedata.append('userId',  this.id); 
    // console.log('form',)

    this.http.post('http://localhost:8080/api/posts/add', filedata, {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});
    this.router.navigate(['/home'])

  }

}
