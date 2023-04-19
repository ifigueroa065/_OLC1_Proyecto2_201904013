import { Component, OnInit } from '@angular/core';
import { AnalizarService } from '../servicios/analizar.service';
import { DataSet } from 'vis';
import * as vis from "vis";

@Component({
  selector: 'app-reportes',
  templateUrl: './reportes.component.html',
  styleUrls: ['./reportes.component.css']
})
//GRAPHVIZ BASADO EN: https://stackoverflow.com/questions/40296821/how-to-make-vis-js-lib-to-work-with-angular2
//CONFIGURACIONES: https://stackoverflow.com/questions/51105775/plotting-huge-trees-with-vis-js
//CREAR DIRECTIVA: https://www.freecodecamp.org/news/angular-directives-learn-how-to-use-or-create-custom-directives-in-angular-c9b133c24442/
//SEPARAR ENTRADA: https://codesandbox.io/s/j2ypy88p1y?file=/src/index.js
export class ReportesComponent implements OnInit {
  
  graphData = {}; 
  parsedData:any;

  salidaE: Array<any> =  this.analizarService.getErrores();    
  salidaS: Array<any> =  this.analizarService.getSimbolos();     
  salidaM: Array<any> =  this.analizarService.getMetodos();
  DOTstring:any = this.analizarService.getDOT();
  constructor(private analizarService: AnalizarService) { }

  ngOnInit(): void {
    this.salidaE =  this.analizarService.getErrores(); 
    this.salidaS =  this.analizarService.getSimbolos();
    this.salidaM =  this.analizarService.getMetodos();
    this.DOTstring = this.analizarService.getDOT();
    this.parsedData = vis.network.convertDot(this.DOTstring);
  }

  ngAfterContentInit(){
    // create an array with nodes
    var nodes = this.parsedData.nodes;

    // create an array with edges
    var edges = this.parsedData.edges;

    // provide the data in the vis format
    this.graphData["nodes"] = nodes;
    this.graphData["edges"] = edges;
  }


}
