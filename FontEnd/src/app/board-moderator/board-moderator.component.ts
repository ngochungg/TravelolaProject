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
  
  form: FormGroup;
  countries: Array<any> = [
    { name: 'India', value: 'india' },
    { name: 'France', value: 'france' },
    { name: 'USA', value: 'USA' },
    { name: 'Germany', value: 'germany' },
    { name: 'Japan', value: 'Japan' }
  ];

  constructor(fb: FormBuilder,private userService: UserService,  private router: Router ) {
    this.form = fb.group({
     selectedCountries:  new FormArray([])
    });
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

  onCheckboxChange(event: any) {
    const selectedCountries = (this.form.controls['selectedCountries'] as FormArray);
    if (event.target.checked) {
      selectedCountries.push(new FormControl(event.target.value));
    } else {
      const index = selectedCountries.controls
      .findIndex(x => x.value === event.target.value);
      selectedCountries.removeAt(index);
    }
  }

  submit() {
    console.log(this.form.value);
  }
}