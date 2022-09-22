import { Component, OnInit } from '@angular/core';
import { UserService } from '../_services/user.service';
import { Router } from '@angular/router';
import { FormGroup, FormBuilder, FormArray, FormControl } from '@angular/forms';
@Component({
  selector: 'app-board-moderator',
  templateUrl: './board-moderator.component.html',
  styleUrls: ['./board-moderator.component.css']
})


export class BoardModeratorComponent implements OnInit {
  all :any[] =[];
  allLoca: any[] = [];
  public dtHotel :string[] = [];
  content?: string;
  

  constructor(fb: FormBuilder,private userService: UserService,  private router: Router ) {
  }

  ngOnInit(): void {
    this.userService.showAllHotel().subscribe({
      next:data=>{
        this.all = data;
       for(var i=0;i<this.all.length;i++) {
        this.allLoca=this.all[i].location
        console.log('allLoca',this.allLoca)
       }
       this.dtHotel = this.allLoca;
      
       
        console.log('this.all: ',this.all)
      }
    }) 
    console.log(this.content);
   
  }

}