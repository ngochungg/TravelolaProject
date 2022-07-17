import { HttpClient } from '@angular/common/http';
import { Component, ElementRef, OnInit ,ViewChild} from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { UserService } from '../_services/user.service';
import { HttpHeaders } from '@angular/common/http';
import { TokenStorageService } from '../_services/token-storage.service';
@Component({
  selector: 'app-allroominhotel',
  templateUrl: './allroominhotel.component.html',
  styleUrls: ['./allroominhotel.component.css'],
  
})
export class AllroominhotelComponent implements OnInit {
  date: Date  = new Date();
  minDate: string;
  rooms:any;
  room:any[]=[];
  Obj :any;
  oj :any;
  user:any;
  public userID!:string;
  public idroom!:any;
  display=true;
  displayForm=false;
  displaySuccess=false;
  loader=false
  IDr:any;
  IDu:any;
  isLogin=false;
  // input date

  constructor(private userService: UserService,private route: ActivatedRoute,private http: HttpClient,private token: TokenStorageService) {

    let dd = String(this.date.getDate()).padStart(2, '0');
    let mm = String(this.date.getMonth() + 1).padStart(2, '0'); //January is 0!
    let yyyy = this.date.getFullYear();

    this.minDate =( yyyy + '-' + mm + '-' + dd) as string;
    console.log(this.minDate)
   }

  ngOnInit(): void {
    

    this.user =this.token.getUser();
   
    if(this.user==null){
      this.isLogin=false;
    }else if(this.user.id >0){
      this.isLogin=true;
    }
    this.IDu=this.user.id;
    this.Obj = this.route.snapshot.paramMap.get('hotel');
    this.oj =JSON.parse(this.Obj)
    this.userService.getAllRoom().subscribe({
      next : data => {
        this.rooms =data;
        for (let i = 0; i < this.rooms.length; i++) {
          if(this.rooms[i].images[0].hotel.id == this.oj)
          {
            this.room.push(this.rooms[i]);
            console.log(this.room)
          }
        }
      }
    });
  
    
  }

  toggle(event:any){
    const id=event.target.value;
    this.IDr=id;
    this.displayForm =!this.displayForm;
    this.display=!this.display;
    
  }

  form:any={
    checkInDate: '',
    checkOutDate:'',
    numOfGuest : '',
    paymentMethod: '',
    totalPrice: '',
    roomId:'',
    userId :'',
  }
  
  bookingRoom(event:any) {
   
    // console.log(this.userId)
    this.idroom=event.target.value;
    this.loader=!this.loader;
    this.displayForm=!this.displayForm;
    // console.log('IDr',this.IDr)
    // console.log('IDu',this.IDu)
    // console.log('form',this.form)
    const {checkInDate,checkOutDate,numOfGuest,paymentMethod,totalPrice,roomId,userId}=this.form;
   this.userService.hotelBooking(this.minDate,checkOutDate,numOfGuest,paymentMethod,totalPrice,this.IDr,this.IDu).subscribe({
   
    next: data => {
      
      this.loader = false;
      this.displaySuccess = !this.displaySuccess;
      console.log(data);
      
    }
    });

  }

}
