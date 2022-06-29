import { Component, OnInit } from '@angular/core';
import { UserService } from '../_services/user.service';
import { AuthService } from '../_services/auth.service';
interface popularCity{
  id : string;
  name : string;
  
}
@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})

export class HomeComponent implements OnInit {
  content?: string;

  constructor(private userService: UserService,private authService: AuthService ) {
   }

   provins: any[] = [];
   citys: popularCity[] = [];
   public popularCity:popularCity[] = [];
  ngOnInit(): void {
    this.authService.getProvince().subscribe({
      next:data => {
        this.provins = data;
        console.log('provins',this.provins)

        for (let i = 0; i < 4; i++) {
          const citys =this.provins[i];
          console.log('city',citys)
          this.popularCity.push(citys);
        }
      
        console.log('popularCity',this.popularCity)

      }
    });
    
   
  }
  reloadPage(): void {
    window.location.reload();
  }
  public gotoCity(event:any): void{
    const gocity=event.target.value;
    console.log('gocity',gocity)


  }
  
}