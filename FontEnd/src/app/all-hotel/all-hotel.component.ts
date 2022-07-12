import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { Router } from '@angular/router';
import { UserService } from '../_services/user.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
interface User {
  id: string;
  username: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  roles: any[];

}
@Component({
  selector: 'app-all-hotel',
  templateUrl: './all-hotel.component.html',
  styleUrls: ['./all-hotel.component.css']
})
export class AllHotelComponent implements OnInit {
  [x: string]: any;
  currentUser: any;
  user: any[] = [];
  _user: User[] = [];
  errorMessage = '';
  users: any[] = [];
  display= true ;
  undis=false

  constructor(private token: TokenStorageService, private authService: AuthService, private tokenStorage: TokenStorageService,
    private router: Router, private userService: UserService,private http:HttpClient) { }
  hotel: any;
  id: any[]=[];
  phone:any;
  dtUser:any;
  
  ngOnInit(): void {
    this.authService.getAllUsers().subscribe({
      next: data=>{
        this.dtUser = data;

      }
    })
    this.userService.showAllHotel().subscribe({
      next: data => {
        this.hotel = data;
        console.log('hotel',  this.hotel)
        for (let i = 0; i < this.hotel.length; i++) {
          const ID = this.hotel[i].account.id;
          this.id.push(ID);
        }

      }
    });

    
  }

  no(user: any): void {
    const index = this.hotel.findIndex((hotel: { id: string; }) => hotel.id === user.id);
    // remove index from hotel list
    this.hotel.splice(index, 1);

    this.authService.refuseHotel(user.id).subscribe({
      next: (data) => {
      
      }
      ,
      error: (err) => {
        
        this.router.navigate(['/home'])
        .then(() => {
          this.reloadPage();
        });
      
      },
    });
  }

  yes(user: User): void {
    const index = this.hotel.findIndex((hotel: { id: string; }) => hotel.id === user.id);
    this.hotel[index] ={...this.hotel[index],status:true}
    // this.reloadPage();
    this.authService.confirmHotel(user.id).subscribe({
      next: (data) => {
       
         
      }
      
    });
  }

 
  unLook(event: any): void {
    
    const userID=event.target.value;

    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
 
    this.http.post('http://localhost:8080/api/auth/unlockUser/'+userID, {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});
    this.reloadPage();
  }
  hotelID :any;  

  Look(event: any): void {
    
    const userID=event.target.value;

    let headers = new HttpHeaders();
    headers.append('Content-Type', 'multipart/form-data');
 
    this.http.post('http://localhost:8080/api/auth/lockUser/'+userID, {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});
    this.reloadPage();
  }

  reloadPage(){
    window.location.reload();
  }
}
