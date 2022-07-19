import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Route, Router } from '@angular/router';
import { render } from 'creditcardpayments/creditCardPayments';

@Component({
  selector: 'app-paypal',
  templateUrl: './paypal.component.html',
  styleUrls: ['./paypal.component.css']
})
export class PaypalComponent implements OnInit {
  value: any;


  constructor(private router:Router,private route: ActivatedRoute) {  }
  Obj:any;
  oj:any;
  ngOnInit(): void {
    this.Obj = this.route.snapshot.paramMap.get('totalPrice');
    this.oj =JSON.parse(this.Obj)
    console.log('totalPrice',this.oj)
    this.value=this.Obj;
    console.log('this.Obj',this.Obj)
    render({
      id:"#myPaypalButtons",
      currency:"USD",
      value:this.oj,
      onApprove:(details)=>{
        alert("Transaction successfull");
      }
      
    })
    
  }

}
