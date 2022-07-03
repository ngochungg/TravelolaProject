import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RoomHotelIDComponent } from './room-hotel-id.component';

describe('RoomHotelIDComponent', () => {
  let component: RoomHotelIDComponent;
  let fixture: ComponentFixture<RoomHotelIDComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RoomHotelIDComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RoomHotelIDComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
