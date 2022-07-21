import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
// import next from 'node_modules(old)/ajv/dist/vocabularies/next';
import { Router } from '@angular/router';

@Component({
  selector: 'app-hotel-service',
  templateUrl: './hotel-service.component.html',
  styleUrls: ['./hotel-service.component.css'],
})
export class HotelServiceComponent implements OnInit {
  constructor(
    private authService: AuthService,
    private http: HttpClient,
    private token: TokenStorageService,
    private userService: UserService,
    private router: Router
  ) { }
  hotel: any;
  rooms: any;
  room: any;
  service: any;
  errorMessage = '';
  idHotel: any;
  display = false;
  form: any = {
    paymentAtTheHotel: null,
    wifi: null,
    freeBreakfast: null,
    freeParking: null,
    petsAllowed: null,
    hotTub: null,
    swimmingPool: null,
    gym: null,
  };


    

  public paymentAtTheHotel! :boolean;
  public wifi! :boolean;
  public phone! :boolean;
  public freeBreakfast! :boolean;
  public freeParking! :boolean;
  public petsAllowed! :boolean;
  public hotTub! :boolean;
  public swimmingPool! :boolean;
  public gym! :boolean;
  ngOnInit(): void {
    this.hotel = this.token.getUser();
    this.userService.showAllHotel().subscribe({
      next: (data) => {
        for (let i = 0; i < data.length; i++) {
          if (data[i].account.username === this.hotel.username) {
            this.rooms = data[i];
            console.log('idHotel', this.rooms);
          }
        }
      },
      error: (err) => {
        
        this.router.navigate(['/home'])
        .then(() => {
          this.reloadPage();
        });
      
      },
    });
  }

  reloadPage(): void {
    window.location.reload();
  }
  ev:any;
  check:any;

  change(event: any): void {
    this.ev=event.target.value;
    console.log('ev',this.ev);
   this.rooms[this.ev]=!this.rooms[this.ev];
    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');

    if(this.ev=="paymentAtTheHotel"){
       this.http.post('http://localhost:8080/api/hotel/addServices/'+this.hotel.id ,{"paymentAtTheHotel":this.rooms[this.ev]},{headers: headers, responseType: 'text'}).subscribe({ next: (data) => {console.log(data)}  , error: (err) => { console.log('err', err); } });
    }else if(this.ev=='wifi'){
      this.http.post('http://localhost:8080/api/hotel/addServices/'+this.hotel.id ,{"wifi":this.rooms[this.ev]},{headers: headers, responseType: 'text'}).subscribe({ next: (data) => {console.log(data)}  , error: (err) => { console.log('err', err); } });
    }else if(this.ev=='freeBreakfast'){
      this.http.post('http://localhost:8080/api/hotel/addServices/'+this.hotel.id ,{"freeBreakfast":this.rooms[this.ev]},{headers: headers, responseType: 'text'}).subscribe({ next: (data) => {console.log(data)}  , error: (err) => { console.log('err', err); } });
    }
    else if(this.ev=='freeParking'){
      this.http.post('http://localhost:8080/api/hotel/addServices/'+this.hotel.id ,{"freeParking":this.rooms[this.ev]},{headers: headers, responseType: 'text'}).subscribe({ next: (data) => {console.log(data)}  , error: (err) => { console.log('err', err); } });
    }
    else if(this.ev=='swimmingPool'){
      this.http.post('http://localhost:8080/api/hotel/addServices/'+this.hotel.id ,{"swimmingPool":this.rooms[this.ev]},{headers: headers, responseType: 'text'}).subscribe({ next: (data) => {console.log(data)}  , error: (err) => { console.log('err', err); } });
    }
    else if(this.ev=='hotTub'){
      this.http.post('http://localhost:8080/api/hotel/addServices/'+this.hotel.id ,{"hotTub":this.rooms[this.ev]},{headers: headers, responseType: 'text'}).subscribe({ next: (data) => {console.log(data)}  , error: (err) => { console.log('err', err); } });
    }
    else if(this.ev=='petsAllowed'){
      this.http.post('http://localhost:8080/api/hotel/addServices/'+this.hotel.id ,{"petsAllowed":this.rooms[this.ev]},{headers: headers, responseType: 'text'}).subscribe({ next: (data) => {console.log(data)}  , error: (err) => { console.log('err', err); } });
    }
    else if(this.ev=='gym'){
      this.http.post('http://localhost:8080/api/hotel/addServices/'+this.hotel.id ,{"gym":this.rooms[this.ev]},{headers: headers, responseType: 'text'}).subscribe({ next: (data) => {console.log(data)}  , error: (err) => { console.log('err', err); } });
    }
   
 

    // this.authService
    //   .service(
    //     this.paymentAtTheHotel,
    //     this.wifi,
    //     this.freeBreakfast,
    //     this.freeParking,
    //     this.petsAllowed,
    //     this.hotTub,
    //     this.swimmingPool,
    //     this.gym
    //   )
    //   .subscribe({
    //     next: (data) => {
    //        this.service=data
    //         console.log('service', this.service);
    //         this.rooms[this.ev]=!this.rooms[this.ev];
    //         console.log('thisev',this.rooms[this.ev])
    //         // this.rooms.push(this.rooms[this.ev]);
            
    //       }
    //   });

 
  }
}
