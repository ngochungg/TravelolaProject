import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Route, Router } from '@angular/router';
import { render } from 'creditcardpayments/creditCardPayments'
@Component({
  selector: 'app-paypal',
  templateUrl: './paypal.component.html',
  styleUrls: ['./paypal.component.css']
})
export class PaypalComponent implements OnInit {

  constructor(private router:Router,private route: ActivatedRoute) {  render({
    id:"#myPaypalButtons",
    currency:"USD",
    value:"1",
    onApprove:(details)=>{
      alert("Transaction successfull");
    }
  });}
  Obj:any;
  oj:any;
  ngOnInit(): void {
    this.Obj = this.route.snapshot.paramMap.get('totalPrice');
    this.oj =JSON.parse(this.Obj)
    console.log('totalPrice',this.oj)
    console.log('this.Obj',this.Obj)
    
  }

}
