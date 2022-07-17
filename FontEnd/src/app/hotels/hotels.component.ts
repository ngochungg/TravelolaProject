import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Observable } from 'rxjs';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
interface Rooms{
  hotelName :string,
  location :number,
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
  constructor(private userService: UserService,private token: TokenStorageService,private http: HttpClient,private router: Router, private route: ActivatedRoute) { }
  currentUser:any;
  hotelRooms :any[] =[];
  room : any[] = [];
  dataRooms:Rooms[] = [];
  searchKeyword: string | null = '';
  Obj! :any;
  oj:any;
  sao:number=0;
  i=0;
  rating:number=0;
  _rating:number=0;
  ngOnInit(): void {
    // this.Obj = JSON.parse(this.route.snapshot.paramMap.get('my_object'));
     this.Obj = this.route.snapshot.paramMap.get('name');
     this.oj =JSON.parse(this.Obj)
     console.log('Obj',this.Obj)
     console.log('oj',this.oj)
    this.userService.allHotel().subscribe({
      next : data => {
        this.hotelRooms = data;
        // console.log('hotelRooms',  this.hotelRooms)
        for (let i = 0; i < this.hotelRooms.length; i++) {
          if(this.hotelRooms[i].location.province.id ==this.oj){
            if(this.hotelRooms[i].status==true){
              this.room.push(this.hotelRooms[i]);
            }       
          }
        }
        console.log('room', this.room)
          // for(this.i=0;this.i<this.room.length;this.i++){
          //   if(this.room[this.i].hotelFeedBacks.length=0){
          //     this.rating=0;
          //   }else if(this.room[this.i].hotelFeedBacks.length>0){
          //     const _sao=this.room[this.i].hotelFeedBacks;
          //     for(let j=0;j<_sao.length;j++){
          //       this.rating +=_sao[j].rating;
              
          //     } 
          //     this._rating=this.rating/this.room[this.i].hotelFeedBacks.length;

          //     console.log('sum',this._rating)
            
          //   }
          // }

       
      }
      
    });
   
  }

  public checkInDate ='';
  public checkOutDate ='';
  public numOfGuest ='';
  public paymentMethod ='';
  public totalPrice ='';
  public roomId ='';
  public userId ='';

  bookrooms(event :any):void{
    const e =event.target.value;
    this.router.navigate(['/allRoom', {hotel: JSON.stringify(e)}]);

  }
  rooms:any;
  search(event:any):void{
    const e =event.target.value;
    

    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    this.http.post('http://localhost:8080/api/hotel/searchHotel/',{"hotelName":this.hotelRooms[e]},{headers: headers, responseType: 'text'}).subscribe({ next: (data) => {console.log(data)}  , error: (err) => { console.log('err', err); } });
  }
}
