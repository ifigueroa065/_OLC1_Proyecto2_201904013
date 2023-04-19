import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { AnalizarService } from 'src/app/servicios/analizar.service';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html',
  styleUrls: ['./editor.component.css']
})
export class EditorComponent implements OnInit {
  form: FormGroup;
  entrada:  string;   //Codigo de entrada. Se envia al analizador.
  salida:  string = "";    //Texto que se va amostrar en consola
  carga: string = "";      //Texto del Codigo
  nameFile: string;

  fileName = '';

  constructor(private analizarService: AnalizarService) { }

  ngOnInit(): void {
    this.form = new FormGroup({
        codigo: new FormControl('', [Validators.required])
      }
    )
  }

  enviarCodigo(): void {
    this.entrada = this.form.controls["codigo"].value; 
    var objeto = {
      entrada: this.entrada,
    }
    this.analizarService.ejecutar(objeto).subscribe((res:any)=>{
      console.log(res)
      this.salida = (res.salida);
      this.analizarService.setErrores(res.errores.lista);
      this.analizarService.setSimbolos(res.simbolos.lista);
      this.analizarService.setMetodos(res.metodos.lista);
      this.analizarService.setDOT(res.ast);
    }, err=>{
      console.log(err)
    });
  }

  //Borra el texto del cuadro
  limpiar():void {
    this.carga = "";
    this.salida = "";
    this.entrada = "";
  }

  guardar():void {
    let element = document.createElement('a');
    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(this.carga));
    const d = new Date();
    this.nameFile = "Archivo Generado_" + d + ".cst";
    element.setAttribute('download', this.nameFile);

    element.style.display = 'none';
    document.body.appendChild(element);

    element.click();

    document.body.removeChild(element);
  }

  abrir(event: any) {
    const lista: Array<File> = event.target.files;

    if(!lista.length) return;
    for(let i = 0;i < lista.length;i++){
      const file:File = lista[i];
      let reader = new FileReader();
      reader.onload = (e) => {
          const file = e.target.result;
          this.carga += "\n"; 
          this.carga += file as string;
      };
      reader.onerror = (e) => alert(e.target.error.name);
      reader.readAsText(file); 
    }
    /*
    const file = event.target.files[0];
    let reader = new FileReader();
    let textarea = document.querySelector('textarea');
    reader.onload = (e) => {
        const file = e.target.result;
        console.log(typeof(file))
        const lines = (file as string).split(/\r\n|\n/);
        this.carga = lines.join('\n');
    };
    reader.onerror = (e) => alert(e.target.error.name);
    reader.readAsText(file); 
    */
  }

}
