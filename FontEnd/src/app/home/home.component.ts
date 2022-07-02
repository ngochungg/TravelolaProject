import { Component, OnInit } from '@angular/core';
import { UserService } from '../_services/user.service';
import { AuthService } from '../_services/auth.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';




@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})


export class HomeComponent implements OnInit {
  in4City: any[] = [];
  public id!: string;

  city: any;
  constructor(private userService: UserService, private http: HttpClient) { }
  public province = '';
  ngOnInit(): void {
    let headers = new HttpHeaders();
    this.userService.showAllHotel().subscribe({
      next: data => {
        this.city = data;
        // console.log('allHotel', this.city)
        for (let i = 0; i < this.city.length; i++) {

          // this.city.image = this.city[i].images[0].imagePath
          // this.city.image = ('http://localhost:8080/api/auth/getImage/' + this.city.image)
          const citys = this.city[i]
          this.in4City.push(citys)
          console.log('in4City', this.in4City)
        }
        this.city
      }

    });



    // this.http.get('http://localhost:8080/api/auth/getImage/'+imagePath , {headers: headers, responseType: 'text'} ).subscribe(res =>{console.log(res)});



    // reloadPage(): void {
    //   window.location.reload();
  }


}