import { Component, OnInit } from '@angular/core';
import { TokenStorageService } from '../_services/token-storage.service';
import { AuthService } from '../_services/auth.service';
@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  currentUser: any;
  constructor(private token: TokenStorageService ) { }

  ngOnInit(): void {
    this.currentUser = this.token.getUser();
    console.log(this.currentUser);
    if(this.currentUser.imageUrl != null){
    this.currentUser.imageUrl = 'http://localhost:8080/api/auth/' + 'getImage/' + this.currentUser.imageUrl;
    }else{
      this.currentUser.imageUrl = 'http://localhost:8080/api/auth/' + 'getImage/' + 'default.png';
    }
  }
}