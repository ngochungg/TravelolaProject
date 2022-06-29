import { HttpEvent } from '@angular/common/http';
import { HttpRequest } from '@angular/common/http';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs/internal/Observable';

@Component({
  selector: 'app-up-image',
  templateUrl: './up-image.component.html',
  styleUrls: ['./up-image.component.css']
})
export class UpImageComponent implements OnInit {
  
  constructor(private http: HttpClient) { }
  selectedFile!: File;
  ngOnInit(): void {
  }

  onFileSelected(event: any){
    this.selectedFile=<File>event.target.files[0];
  }

  onUpload(){
    const filedata =new FormData();
    filedata.append('file', this.selectedFile, this.selectedFile.name);
    this.http.post('http://localhost:8080/api/auth/uploadImage/2', filedata).subscribe(res =>{console.log(res)});
  }
}
