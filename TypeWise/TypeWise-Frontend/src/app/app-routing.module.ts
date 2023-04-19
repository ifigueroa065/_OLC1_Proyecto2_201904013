import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EditorComponent } from './editor/editor.component';
import { ReportesComponent } from './reportes/reportes.component';

const routes: Routes = [{path:"", component:EditorComponent}, {path:"reportes", component:ReportesComponent}];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
