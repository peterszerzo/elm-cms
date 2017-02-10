require('./main.css');
var Elm = require('./Main.elm');

var API_URL = 'http://localhost:3001/';

var app = Elm.Main.embed(global.document.getElementById('root'), API_URL);

// Handle file uploads
// Callback is called every time the file input field changes.
// When image is uploaded, ship its url back to the fileUploaded port.
app.ports.uploadFile.subscribe(function(id) {
  var node = global.document.getElementById(id);
  var file = node.files[0];
  if (!file) {
    return;
  }
  setTimeout(function() {
    app.ports.fileUploaded.send('http://images.com/1234.png');
  }, 1000);
  var reader = new global.FileReader();
  reader.onload = function(res) {
    console.log(reader.result);
  };
  reader.readAsDataURL(file);
});
