import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';

@Component({
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.css']
})
export class AboutComponent implements OnInit {
  // currentUser: any;
  viewProfile: any;
  constructor(private token: TokenStorageService,private authService: AuthService) { }

  ngOnInit(): void {
    this.authService.reloadPro().subscribe({
      next: data => {
        // console.log(data);
        this.viewProfile = data;
        console.log(this.viewProfile);
        // this.reloadPage();
      }
    });
  }

}
