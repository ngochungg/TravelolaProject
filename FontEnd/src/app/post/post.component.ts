import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { AuthService } from '../_services/auth.service';

@Component({
  selector: 'app-post',
  templateUrl: './post.component.html',
  styleUrls: ['./post.component.css']
})

export class PostComponent implements OnInit {

  constructor(private route: ActivatedRoute,private authService: AuthService ) { }
  Obj! :any;
  oj:any;
  posts: any[]=[];
  post:any;
  ngOnInit(): void {
    this.Obj = this.route.snapshot.paramMap.get('postpage');
    this.oj =JSON.parse(this.Obj)
    console.log('Obj',this.Obj)
     console.log('oj',this.oj)

     this.authService.getPost(this.oj).subscribe({
      next : data => {
       this.post=data;
      //  this.posts.push(this.post);
       console.log('posts',this.post)
      }
     });
  }

}
