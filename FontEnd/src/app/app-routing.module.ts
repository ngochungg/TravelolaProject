import { NgModule } from '@angular/core';

import { RouterModule, Routes } from '@angular/router';

import { RegisterComponent } from './register/register.component';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { ProfileComponent } from './profile/profile.component';
import { BoardUserComponent } from './board-user/board-user.component';
import { BoardModeratorComponent } from './board-moderator/board-moderator.component';
import { BoardAdminComponent } from './board-admin/board-admin.component';
import { AboutComponent } from './about/about.component';
import { ContacComponent } from './contac/contac.component';
import { UpdateComponent } from './update/update.component';
import  { AllAdminComponent } from './all-admin/all-admin.component';
import  { AllHotelComponent } from './all-hotel/all-hotel.component';
import  { AllUserComponent }  from './all-user/all-user.component';
import  { DashboardComponent } from './dashboard/dashboard.component'; 
import  { CategoryComponent } from './category/category.component';
import  { RegisterHotelComponent } from './register-hotel/register-hotel.component';
import { NgClass } from '@angular/common';


const routes: Routes = [
  { path: 'home', component: HomeComponent },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'profile', component: ProfileComponent },
  { path: 'user', component: BoardUserComponent },
  { path: 'mod', component: BoardModeratorComponent },
  { path: 'admin', component: BoardAdminComponent },
  { path: 'about', component: AboutComponent },
  { path: 'update', component: UpdateComponent },
  { path: 'contac', component: ContacComponent },
  { path: 'alladmin', component: AllAdminComponent },
  { path: 'allhotel', component: AllHotelComponent },
  { path: 'alluser', component: AllUserComponent },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'category', component: CategoryComponent },
  { path: 'register-hotel', component: RegisterHotelComponent },

  { path: '', redirectTo: 'home', pathMatch: 'full' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
