import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
interface Rooms{
  roomName :string,
  roomNumber :number,
  roomType :string,
  price :number,
  maxAdult :number,
  maxChildren: number,
  images:any[]

}
@Component({
  selector: 'app-hotels',
  templateUrl: './hotels.component.html',
  styleUrls: ['./hotels.component.css']
})

export class HotelsComponent implements OnInit {
  constructor(private userService: UserService,private token: TokenStorageService,private http: HttpClient) { }
  currentUser:any;
  hotelRooms :any[] =[];
  room : Rooms[] = [];
  dataRooms:Rooms[] = [];
  searchKeyword: string | null = '';
  ngOnInit(): void {
    this.userService.allHotelRooms().subscribe({
      next : data => {
        this.hotelRooms = data;
        console.log('hotelRooms',  this.hotelRooms)
        for (let i = 0; i < this.hotelRooms.length; i++) {
          
          
            this.room.push(this.hotelRooms[i]);
          
        }
        console.log('room', this.room)
        this.dataRooms=[...this.room]
        console.log('dataRooms', this.dataRooms)
      }
    });
  }

  searchRooms(event: any) {
    this.searchKeyword = event.target.value;
    if (this.searchKeyword===null || this.searchKeyword==='') {
      this.room = this.dataRooms;
    } else {
      if(this.searchKeyword.length>0){
        console.log(this.searchKeyword);
        const userFilted = this.dataRooms.filter((use) =>
          use.roomName.toLowerCase().includes(this.searchKeyword!=null ? this.searchKeyword.toLowerCase() : '')
        );
        this.room = userFilted;
      }
    }
  }
  public checkInDate ='';
  public checkOutDate ='';
  public numOfGuest ='';
  public paymentMethod ='';
  public totalPrice ='';
  public roomId ='';
  public userId ='';

  bookrooms(){
    this.currentUser=this.token.getUser();
    console.log('currentUser', this.currentUser);
 
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    const filedata =new FormData();

    filedata.append('checkInDate', this.checkInDate);
    filedata.append('checkOutDate',  this.checkOutDate);
    filedata.append('numOfGuest',  this.numOfGuest);
    filedata.append('paymentMethod',  this.paymentMethod); 
    filedata.append('totalPrice',  this.totalPrice);
    filedata.append('roomId',  this.roomId);
    filedata.append('userId',  this.userId);


    this.http.post('http://localhost:8080/api/hotel/hotelBooking', filedata, {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});
  

  }
}
