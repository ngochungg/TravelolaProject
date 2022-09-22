import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AllroominhotelComponent } from './allroominhotel.component';

describe('AllroominhotelComponent', () => {
  let component: AllroominhotelComponent;
  let fixture: ComponentFixture<AllroominhotelComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AllroominhotelComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AllroominhotelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
