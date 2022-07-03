import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { TokenStorageService } from '../_services/token-storage.service';
import { UserService } from '../_services/user.service';
@Component({
  selector: 'app-hotel-service',
  templateUrl: './hotel-service.component.html',
  styleUrls: ['./hotel-service.component.css']
})
export class HotelServiceComponent implements OnInit {

  constructor(private authService: AuthService, private http: HttpClient, private token: TokenStorageService,private userService: UserService) { }

  ngOnInit(): void {
  }

}
