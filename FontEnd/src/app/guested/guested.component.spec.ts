import { ComponentFixture, TestBed } from '@angular/core/testing';

import { GuestedComponent } from './guested.component';

describe('GuestedComponent', () => {
  let component: GuestedComponent;
  let fixture: ComponentFixture<GuestedComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ GuestedComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(GuestedComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
