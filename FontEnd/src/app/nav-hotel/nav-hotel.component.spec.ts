import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NavHotelComponent } from './nav-hotel.component';

describe('NavHotelComponent', () => {
  let component: NavHotelComponent;
  let fixture: ComponentFixture<NavHotelComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ NavHotelComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(NavHotelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
