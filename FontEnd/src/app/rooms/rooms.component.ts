import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { TokenStorageService } from '../_services/token-storage.service';
@Component({
  selector: 'app-rooms',
  templateUrl: './rooms.component.html',
  styleUrls: ['./rooms.component.css']
})
export class RoomsComponent implements OnInit {
  constructor(private authService: AuthService, private http: HttpClient, private token: TokenStorageService) { }

  currentUser: any;
  errorMessage = '';
  
  selectedFile!: File;

  ngOnInit(): void {
    this.currentUser = this.token.getUser();
    this.authService.reloadPro().subscribe({
      next: data => {
        // console.log(data);
        this.currentUser.id = data.id;
        console.log('id', this.currentUser.id);

      },
      error: err => {
        this.errorMessage = err.error.message;
      }
    });

  }

  onFileSelected(event: any) {
    this.selectedFile = <File>event.target.files;
    console.log('event', this.selectedFile)
  }
  public roomNumber = '';
  public roomName = '';
  public roomType = '';
  public price = '';
  public maxAdult = '';
  public maxChildren = '';
  public images = '';
  onUpload() {
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata = new FormData();
    filedata.append('images', this.selectedFile, this.selectedFile.name);
    filedata.append('roomNumber', this.roomNumber);
    filedata.append('roomName', this.roomName);
    filedata.append('roomType', this.roomType);
    filedata.append('price', this.price);
    filedata.append('maxAdult', this.maxAdult);
    filedata.append('maxChildred', this.maxChildren);

    // console.log('form',)

    this.http.post('http://localhost:8080/api/hotel/addRoom/' + this.currentUser.id, filedata).subscribe(res => { console.log(res) });
  
  }
}
