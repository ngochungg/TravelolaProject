import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpdateAvataComponent } from './update-avata.component';

describe('UpdateAvataComponent', () => {
  let component: UpdateAvataComponent;
  let fixture: ComponentFixture<UpdateAvataComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ UpdateAvataComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UpdateAvataComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
