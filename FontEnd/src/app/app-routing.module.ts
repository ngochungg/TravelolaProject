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
import { AllAdminComponent } from './all-admin/all-admin.component';
import { AllHotelComponent } from './all-hotel/all-hotel.component';
import { AllUserComponent } from './all-user/all-user.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { CategoryComponent } from './category/category.component';
import { RegisterHotelComponent } from './register-hotel/register-hotel.component';
import { CityComponent } from './city/city.component';
import { UpImageComponent } from './up-image/up-image.component';
import { RoomsComponent } from './rooms/rooms.component';
import { HotelsComponent } from './hotels/hotels.component';
import { RoomHotelIDComponent } from './room-hotel-id/room-hotel-id.component';
import { HotelServiceComponent } from './hotel-service/hotel-service.component';
import { UserBookingHistoryComponent } from './user-booking-history/user-booking-history.component';
import { ForgotPasswordComponent } from './forgot-password/forgot-password.component';
import { AllroominhotelComponent } from './allroominhotel/allroominhotel.component';
import { BookingComponent } from './booking/booking.component';
import { PostComponent } from './post/post.component';
import { AddpostComponent } from './addpost/addpost.component';
import { GuestBookingComponent } from './guest-booking/guest-booking.component';
import { GuestedComponent } from './guested/guested.component';
import { PaypalComponent } from './paypal/paypal.component';

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
  { path: 'city', component: CityComponent },
  { path: 'upImage', component: UpImageComponent },
  { path: 'rooms', component: RoomsComponent },
  { path: 'hotels', component: HotelsComponent },
  { path: 'room-hotelID', component: RoomHotelIDComponent },
  { path: 'hotel-service', component: HotelServiceComponent },
  { path: 'user-booking-history', component: UserBookingHistoryComponent},
  { path: 'forgot-password', component: ForgotPasswordComponent },
  { path: 'allRoom',component: AllroominhotelComponent},
  { path: 'booking',component: BookingComponent},
  { path: 'post',component: PostComponent},
  { path: 'addpost',component: AddpostComponent},
  { path: 'guest-booking',component: GuestBookingComponent},
  { path: 'guested',component: GuestedComponent},
  { path: 'paypal',component: PaypalComponent},
  { path: '', redirectTo: 'home', pathMatch: 'full' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
