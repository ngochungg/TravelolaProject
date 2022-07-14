import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';


@Component({
  selector: 'app-guested',
  templateUrl: './guested.component.html',
  styleUrls: ['./guested.component.css']
})
export class GuestedComponent implements OnInit {

  constructor(private token: TokenStorageService,private userService: UserService, private http: HttpClient,private router: Router,private authService: AuthService) { }
  
  user:any;
  id:any;
  usersID:any;
  ngOnInit(): void {
    this.userService.getAllBookingRetiredTrue().subscribe({
      next: (data) => {
        this.usersID=data;
        console.log('data', this.usersID);
      }
    });
  }

}
