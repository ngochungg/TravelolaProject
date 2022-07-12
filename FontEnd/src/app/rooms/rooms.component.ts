import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
@Component({
  selector: 'app-rooms',
  templateUrl: './rooms.component.html',
  styleUrls: ['./rooms.component.css']
})
export class RoomsComponent implements OnInit {
  constructor(private authService: AuthService, private http: HttpClient, private token: TokenStorageService,private userService: UserService) { }
  roomHotel: any;
  rooms: any;
  errorMessage = '';
  id: any;
  selectedFile!: File;
  display=false;
  form=true;

  ngOnInit(): void {
    this.roomHotel = this.token.getUser();
    this.userService.showAllHotel().subscribe({
      next: data => {
        console.log('data', data)
        for (let i = 0; i < data.length; i++) {
          if (data[i].phone === this.roomHotel.phone) {
            this.id = data[i].id
          }
        }
        this.userService.allRooms(this.id).subscribe({
          next: data => {
            this.rooms = data;
            console.log('allrooms', this.rooms);

          }

        })
        console.log('idHotel', this.id)
        // console.log(data)
        // console.log('id', this.roomHotel.id);

      },
      error: err => {
        this.errorMessage = err.error.message;
      }
    });


  }

  onFileSelected(event: any) {
    this.selectedFile = <File>event.target.files[0];
    console.log('event', this.selectedFile)
    console.log('imageName', this.selectedFile.name)
  }
  public roomNumber = '';
  public roomName = '';
  public roomType = '';
  public price = '';
  public maxAdult = '';
  public maxChildren = '';
  public images = '';
  onUpload() {
    this.form=!this.form;
    this.display=!this.display;

    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata = new FormData();
    filedata.append('images',this.selectedFile,this.selectedFile.name);
    filedata.append('roomNumber', this.roomNumber);
    filedata.append('roomName', this.roomName);
    filedata.append('roomType', this.roomType);
    filedata.append('price', this.price);
    filedata.append('maxAdult', this.maxAdult);
    filedata.append('maxChildred', this.maxChildren);

    // console.log('form',)

    this.http.post('http://localhost:8080/api/hotel/addRoom/'+this.id  , filedata).subscribe(res =>{console.log(res)});
  
  }
}
