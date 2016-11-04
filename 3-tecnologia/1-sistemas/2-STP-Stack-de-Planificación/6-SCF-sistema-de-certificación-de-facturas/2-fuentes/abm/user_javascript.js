$(document).ready(function() {
  // Armando nombre de JS a cargar
  var jsFile = window.location.pathname;
  jsFile = jsFile.substring(jsFile.lastIndexOf('/')+1);
  jsFile = jsFile.substring(0,jsFile.indexOf('.')) + '.js';

  // Cargando JS general y particular
  loadJs("general.js");
  loadJs(jsFile);
});

function loadJs(jsFile) {
  // Cargando JS solicitado
  $.getScript(jsFile)
    .done(function(script, textStatus) {
      //console.log(jsFile + ' load: ' + textStatus);
    })
    .fail(function(jqxhr, settings, exception) {
      // Si la carga da error, volvemos a intentar
      setTimeout(function() {
        $.getScript(jsFile)
          .done(function(script, textStatus) {
            //console.log(jsFile + ' load: ' + textStatus);
          })
          .fail(function(jqxhr, settings, exception) {
            // Si vuelve a dar error abostamos
            //alert("Error al cargar la pagina, por favor actualice con F5\n\nProblema: " + jsFile);
          })
      }, 50); 
    })
}