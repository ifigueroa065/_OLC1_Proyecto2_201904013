import { Directive, TemplateRef, ViewContainerRef, Input, Renderer2, ElementRef } from '@angular/core';
import { Network } from 'vis';
@Directive({
    selector: '[appGraphVis]'
})
export class AppNotDirective {
    network;

    constructor(private el: ElementRef) {}
  
    @Input() set appGraphVis(graphData){
      console.log('graph data ', graphData);
      var options = {
        autoResize: true,
    height: '400px',
    clickToUse: false,
    layout: {
        hierarchical: {
            direction: 'UD',
            sortMethod: 'directed',
        }
    },
    physics: {
       stabilization: false,
       barnesHut: {
            gravitationalConstant: -80000,
            springConstant: 0.001,
            springLength: 200
       }
    },
    nodes: {
        shape: 'dot'
    },
      };
  
      if(!this.network){
        this.network = new Network(this.el.nativeElement, graphData, options);
      }
    }
}