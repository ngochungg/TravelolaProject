import { Component, OnInit } from '@angular/core';
import { AuthService } from '../_services/auth.service';
import { TokenStorageService } from '../_services/token-storage.service';
import { Router } from '@angular/router';


// export class User{
//   constructor(
//     public id: number,
//     public username :string,
//     public firstName :string,
//     public lastName :string,
//     public email  :string,
//     public phone : number
//   ){}
// }

@Component({
  selector: 'app-all-admin',
  templateUrl: './all-admin.component.html',
  styleUrls: ['./all-admin.component.css']
})

export class AllAdminComponent implements OnInit {
  [x: string]: any;
  currentUser: any;

  errorMessage = '';

  //array of users
  users: any[] = [];


  constructor(private token: TokenStorageService, private authService: AuthService, private tokenStorage: TokenStorageService,
    private router: Router) { }

  ngOnInit(): void {
    this.authService.getAllUsers().subscribe({
      next: data => {

        //get user roles ROLE_ADMIN in data and push to users array
        for (let i = 0; i < data.length; i++) {
          //get rolename from data
          let role = data[i].roles[0].name;
          if (role == "ROLE_ADMIN") {
            this.users.push(data[i]);
          }
        }
        console.log(this.users);
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

}
