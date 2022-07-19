import { HttpClient } from '@angular/common/http';
import { ActivatedRoute, Router } from '@angular/router';
import { UserService } from '../_services/user.service';
import { HttpHeaders } from '@angular/common/http';
import { TokenStorageService } from '../_services/token-storage.service';
import { Component, ViewEncapsulation, ViewChild,OnInit } from "@angular/core";
import { SwiperComponent } from "swiper/angular";
import SwiperCore, {EffectFade, Pagination ,Autoplay,Navigation } from "swiper";
import {AutoplayOptions} from "swiper/types";

SwiperCore.use([EffectFade,Pagination,Autoplay,Navigation]);
@Component({
  selector: 'app-allroominhotel',
  templateUrl: './allroominhotel.component.html',
  styleUrls: ['./allroominhotel.component.css'],
  
})
export class AllroominhotelComponent implements OnInit {

  
  pagination = {
    clickable: true,
   
  };
  slidesPerView=1
    spaceBetween=3
    loop=true
    navigation=true
  autoplay: AutoplayOptions | boolean = {
    delay: 3000,
    disableOnInteraction: false,
   
  }
  date: Date  = new Date();
  minDate: string;
  maxDate: string;
  rooms:any;
  room:any[]=[];
  Obj :any;
  oj :any;
  user:any;
  public userID!:string;
  public idroom!:any;
  viewRoomID:any;
  display=true;
  fbk=true;
  viewRoom=false;
  displayForm=false;
  displaySuccess=false;
  loader=false
  IDr:any;
  IDu:any;
  isLogin=false;
  ttPrice:any;
  showErroLogin=false;
  // input date
  allFeedBackOfHotelID:any;
  total:any;
  constructor(private router :Router,private userService: UserService,private route: ActivatedRoute,private http: HttpClient,private token: TokenStorageService) {

    let dd = String(this.date.getDate()).padStart(2, '0');
    let mm = String(this.date.getMonth() + 1).padStart(2, '0'); //January is 0!
    let yyyy = this.date.getFullYear();

    let ddd=String(this.date.getDate()+1).padStart(2, '0');
    this.minDate =( yyyy + '-' + mm + '-' + dd) as string;
    this.maxDate=(yyyy + '-' + mm + '-' + ddd) as string;
    

   
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
           
          } 
        }
        // console.log('allroom',this.room)
      }
    });
  
    this.userService.getAllFeedBack(this.oj).subscribe({

      next : data => {
        this.allFeedBackOfHotelID=data;
        // console.log('allFeedBackOfHotelID',this.allFeedBackOfHotelID)
        }
      });
    }

    
  
    pri:any;
  view(event:any){
    const id=event.target.value;
    this.IDr=id;
        console.log('IDr',this.IDr)
    for(let i=0;i<this.room.length;i++){
      if(this.room[i].id==this.IDr){
        this.viewRoomID=this.room[i];
        this.pri=this.room[i].price;
        // console.log('viewRoomID',this.viewRoomID)
        // console.log('pri',this.pri)
      }
    }

    this.viewRoom =!this.viewRoom;

    this.display=!this.display;
    this.fbk=!this.fbk;
    

  }
  booking(event:any){
    const id=event.target.value;
    this.IDr=id;
    this.viewRoom =!this.viewRoom;
    this.showErroLogin=true;
    this.displayForm=!this.displayForm;
    
  }
  evCheckin:any;
  evCheckout:any;
  checkin(event:any){
    this.evCheckin=event.target.value;
   
    const day=new Date(this.evCheckout).getTime() - new Date(this.evCheckin).getTime();

    this.ttPrice = Math.floor(day / (1000 * 60 * 60 * 24)) ;

    this.total=this.pri * this.ttPrice;
  }
  checkout(event:any){
    this.evCheckout=event.target.value;


    const day=new Date(this.evCheckout).getTime() - new Date(this.evCheckin).getTime();

    this.ttPrice = Math.floor(day / (1000 * 60 * 60 * 24)) ;

    this.total=this.pri * this.ttPrice;

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

    const {checkInDate,checkOutDate,numOfGuest,paymentMethod,totalPrice,roomId,userId}=this.form;
   this.userService.hotelBooking(this.evCheckin,this.evCheckout,numOfGuest,paymentMethod,this.total,this.IDr,this.IDu).subscribe({
   
    next: data => {
      // console.log(checkInDate)
      this.loader = false;
      this.displaySuccess = !this.displaySuccess;
      console.log(data);
      
    }
    });

  }
  sub=false;
  submit(){
    this.sub=true;
  }
changepaymentMethod(event:any){
  const pm=event.target.value;
  console.log(pm)
  this.router.navigate(['/paypal',{ totalPrice: JSON.stringify(pm) }]);
}
}
