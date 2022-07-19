import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
import { Router } from '@angular/router';
@Component({
  selector: 'app-rooms',
  templateUrl: './rooms.component.html',
  styleUrls: ['./rooms.component.css']
})
export class RoomsComponent implements OnInit {
  constructor(private router: Router,private authService: AuthService, private http: HttpClient, private token: TokenStorageService,private userService: UserService) { }
  roomHotel: any;
  rooms: any;
  errorMessage = '';
  id: any;

  display=false;
  form=true;

  ngOnInit(): void {
    this.roomHotel = this.token.getUser();
    this.userService.showAllHotel().subscribe({
      next: data => {
        console.log('data', data)
        for (let i = 0; i < data.length; i++) {
          if  (data[i].account.username === this.roomHotel.username) {
            this.id = data[i].id
          }
        }
        // this.userService.allRooms(this.id).subscribe({
        //   next: data => {
        //     this.rooms = data;
        //     console.log('allrooms', this.rooms);

        //   }

        // })


      },
      error: (err) => {

        this.router.navigate(['/home'])
        .then(() => {
          this.reloadPage();
        });

      }
    });


  }
  reloadPage(): void {
    window.location.reload();
  }
  selectedFile!: File[];
  img:File[]=[];
  imgsrc:any;
  onFileSelected(event: any) {
    this.selectedFile = event.target.files;
    for(let file of this.selectedFile) {
      this.img.push(file);
      console.log('this.img',this.img);
    }

    // this.imgsrc=new FileReader().readAsDataURL(this.selectedFile[0]);
    // this.imgsrc=this.selectedFile;
    // console.log('imgSRC',this.imgsrc)
  }
  public roomNumber = '';
  public roomName = '';
  public roomType = '';
  public price = '';
  public maxAdult = '';
  public maxChildren = '';
  public images = '';
  i:number=0;
  onUpload() {
    this.form=!this.form;
    this.display=!this.display;

    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata = new FormData();

  
    for(this.i=0;this.i<this.img.length;this.i++) {
      filedata.append('images', this.img[this.i]);
      console.log('imgsrc',this.img)
    }
      // filedata.append('images',img);

    filedata.append('roomNumber', this.roomNumber);
    filedata.append('roomName', this.roomName);
    filedata.append('roomType', this.roomType);
    filedata.append('price', this.price);
    filedata.append('maxAdult', this.maxAdult);
    filedata.append('maxChildren', this.maxChildren);


    console.log('filedata', filedata);

    // console.log('form',)

    this.http.post('http://localhost:8080/api/hotel/addRoom/'+this.id  , filedata).subscribe(res =>{console.log(res)});

  }
  erro=false;
  erroUpload(){
    this.erro=true;
  }
}
