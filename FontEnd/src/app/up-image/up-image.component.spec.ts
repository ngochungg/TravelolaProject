import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpImageComponent } from './up-image.component';

describe('UpImageComponent', () => {
  let component: UpImageComponent;
  let fixture: ComponentFixture<UpImageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ UpImageComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UpImageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
