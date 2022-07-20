import { Component, OnInit } from '@angular/core';
import { UserService } from '../_services/user.service';
import { AuthService } from '../_services/auth.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { TokenStorageService } from '../_services/token-storage.service';



@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})


export class HomeComponent implements OnInit {

  in4City: any[] = [];
  public id!: string;
  posts: any;
  city: any;
  hotel: any;
  user:any;
  room:any;
  to:any;
  constructor(private token: TokenStorageService ,private userService: UserService, private http: HttpClient,private router: Router,private authService: AuthService) { }
  public province = '';
  ngOnInit(): void {
    this.to=this.token.getUser();
    console.log('to',this.to)
    this.userService.find4ProvinceHaveMostHotel().subscribe({
      next: data => {
        this.city = data;

        
      }

    });

    this.userService.allHotel().subscribe({
      next: data => {
        this.hotel = data;
 
      }
    }); 

    this.authService.getAllUsers().subscribe({
      next: data => {
        this.user = data;
        console.log('user',this.user)
   
      }
    });
    this.userService.getAllRoom().subscribe({

      next: data => {
        this.room = data;
      }
    });
    this.authService.postAll().subscribe({
      next:data=>{
        this.posts=data;
      }
    });
  }
  ev(event :any): void {
    const e =event.target.value;
  
    this.router.navigate(['/hotels', {name: JSON.stringify(e)}]);
  }
  acc:any;
  like(event:any){

    const e =event.target.value;
    const index = this.posts.findIndex((posts: { id: string; }) => posts.id === e);
    this.posts[index] ={...this.posts[index],status:true}
    this.authService.like(e).subscribe({
      next:data=>{
        console.log(data)
      }
    });
    console.log('event',e)
  }
  
  gotopost(event:any):void{
    
    console.log('e',event)
    this.router.navigate(['/post', {postpage: JSON.stringify(event)}]);
  }

  addPost():void{
    this.router.navigate(['/addpost']);
  }
}