import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';
import { HomeComponent } from './home/home.component';
import { ProfileComponent } from './profile/profile.component';
import { BoardAdminComponent } from './board-admin/board-admin.component';
import { BoardModeratorComponent } from './board-moderator/board-moderator.component';
import { BoardUserComponent } from './board-user/board-user.component';

import { authInterceptorProviders } from './_helpers/auth.interceptor';
import { FacebookLoginProvider, GoogleLoginProvider, SocialAuthServiceConfig, SocialLoginModule } from '@abacritt/angularx-social-login';
import { AboutComponent } from './about/about.component';
import { ContacComponent } from './contac/contac.component';
import { UpdateComponent } from './update/update.component';
import { NavbarComponent } from './navbar/navbar.component';
import { AllAdminComponent } from './all-admin/all-admin.component';
import { FooterComponent } from './footer/footer.component';
import { AllHotelComponent } from './all-hotel/all-hotel.component';
import { AllUserComponent } from './all-user/all-user.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { CategoryComponent } from './category/category.component';
import { RegisterHotelComponent } from './register-hotel/register-hotel.component';
// import {MatButtonModule} from '@angular/material/button';
// import {MatIconModule} from '@angular/material/icon';
// import {MatToolbarModule} from '@angular/material/toolbar';









@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RegisterComponent,
    HomeComponent,
    ProfileComponent,
    BoardAdminComponent,
    BoardModeratorComponent,
    BoardUserComponent,
    AboutComponent,
    ContacComponent,
    UpdateComponent,
    NavbarComponent,
    AllAdminComponent,
    FooterComponent,
    AllHotelComponent,
    AllUserComponent,
    DashboardComponent,
    CategoryComponent,
    RegisterHotelComponent,

 
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    SocialLoginModule,
    ReactiveFormsModule
  ],
  providers:
  [[authInterceptorProviders],[
    {
      provide: 'SocialAuthServiceConfig',
      useValue: {
        autoLogin: false,
        providers: [
          {
            id: GoogleLoginProvider.PROVIDER_ID,
            provider: new GoogleLoginProvider(
              '122183237481-du4r7jloea4l4ibqcictc8kc9cqf45r7.apps.googleusercontent.com',
              {
                scope: 'email',
                plugin_name: 'travelola'
              }
            )
          },
          {
            id: FacebookLoginProvider.PROVIDER_ID,
            provider: new FacebookLoginProvider('129176942572264')
          }
        ],
        onError: (err) => {
          console.error(err);
        }
      } as SocialAuthServiceConfig,
    }
  ]
],

  bootstrap: [AppComponent]
})
export class AppModule { }
