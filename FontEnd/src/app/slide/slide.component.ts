
import { Component, ViewEncapsulation, ViewChild,OnInit } from "@angular/core";
import { SwiperComponent } from "swiper/angular";
import SwiperCore, {EffectFade, Pagination ,Autoplay,Navigation } from "swiper";
import {AutoplayOptions} from "swiper/types";
SwiperCore.use([EffectFade,Pagination,Autoplay,Navigation]);

@Component({
  selector: 'app-slide',
  templateUrl: './slide.component.html',
  styleUrls: ['./slide.component.css']
})
export class SlideComponent implements OnInit {
  pagination = {
    clickable: true,
   
  };
  slidesPerView=1
    spaceBetween=3
    loop=true
    navigation=true
  autoplay: AutoplayOptions | boolean = {
    delay: 3000,
    disableOnInteraction: false,
   
  }

  constructor() { }

  ngOnInit(): void {
  }

}
