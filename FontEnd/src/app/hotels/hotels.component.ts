import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Observable } from 'rxjs';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
interface Rooms {
  hotelName: string,
  location: string,
  roomType: string,
  price: number,
  maxAdult: number,
  maxChildren: number,
  images: any[],
  province:string,

}
@Component({
  selector: 'app-hotels',
  templateUrl: './hotels.component.html',
  styleUrls: ['./hotels.component.css']
})

export class HotelsComponent implements OnInit {
  constructor(private userService: UserService,private authService: AuthService, private token: TokenStorageService, private http: HttpClient, private router: Router, private route: ActivatedRoute) { }
  currentUser: any;
  hotelRooms: any[] = [];
  room: any[] = [];
  dataRooms: Rooms[] = [];
  searchKeyword: string | null = '';
  Obj!: any;
  oj: any;
  sao: string | undefined;

  rating:number=0;
  _rating:any;
  _room: any[] = [];
  provin: any[] = [];
  dis: any[] = [];
  ngOnInit(): void {

    this.Obj = this.route.snapshot.paramMap.get('name');
    this.oj = JSON.parse(this.Obj)

    this.userService.allHotel().subscribe({
      next: data => {
        this.hotelRooms = data;

        for (let i = 0; i < this.hotelRooms.length; i++) {
          if (this.hotelRooms[i].location.province.id == this.oj) {
            if (this.hotelRooms[i].status == true) {
              this.room.push(this.hotelRooms[i]);
          
            }
          }
        }
        this._room = [...this.room];
        console.log('room', this.room)
        // for (const element of this.room) {
        //   if (element.hotelFeedBacks != null) {
        //     const _sao = element.hotelFeedBacks;
        //     for (const element of _sao) {
        //       this.rating += element.rating;
        //     }
        //     this._rating = this.rating / element.hotelFeedBacks.length;
        //     console.log('_rating', this._rating)
        //   } else if (element.hotelFeedBacks = null) {
           
        //   }
        // }


      }

    });

    this.authService.getDistrict(this.oj).subscribe({
      next: data => {
        this.provin = data;
        console.log(this.provin);
      }
    });

  }

  public checkInDate = '';
  public checkOutDate = '';
  public numOfGuest = '';
  public paymentMethod = '';
  public totalPrice = '';
  public roomId = '';
  public userId = '';
  public province ='';
  public district ='';
  bookrooms(event: any): void {
    const e = event.target.value;
    this.router.navigate(['/allRoom', { hotel: JSON.stringify(e) }]);

  }
  rooms: any;
  search(event: any): void {
    const e = event.target.value;


    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
    this.http.post('http://localhost:8080/api/hotel/searchHotel/', { "hotelName": this.hotelRooms[e] }, { headers: headers, responseType: 'text' }).subscribe({ next: (data) => { console.log(data) }, error: (err) => { console.log('err', err); } });
  }

  searchHotelName(event: any) {
    this.searchKeyword = event.target.value;
    if (this.searchKeyword === null || this.searchKeyword === '') {
      this.room = this._room;
    } else {
      if (this.searchKeyword.length > 0) {
        console.log(this.searchKeyword);
        const userFilted = this._room.filter((use) =>
          use.hotelName.toLowerCase().includes(this.searchKeyword != null ? this.searchKeyword.toLowerCase() : '')
        );
        this.room = userFilted;
      }
    }
  }

  getLocation(event: any) {
    const searchKeyword = event.target.value;
    this.province = searchKeyword

    
    this.authService.getDistrict(this.oj).subscribe({
      next: data => {
        this.dis = data;
      }
    });

    if (this.province === null || this.province === '') {
      this.room = this._room;
    } else {
      if (this.province.length > 0) {
        console.log(this.province);
        const userFilted = this._room.filter((use) =>
          use.location.district.name.toLowerCase().includes(this.province != null ? this.province.toLowerCase() : '')
        );
        this.room = userFilted;
      }
    }
  }



}
