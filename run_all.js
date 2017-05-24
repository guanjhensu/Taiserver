var express = require('express');
var multer = require('multer');
var path = require('path');
var crypto = require('crypto');

var app = new express();
app.listen(3000, console.log("Listening on port 3000"));


// get image from client
var storage = multer.diskStorage({
  destination: './uploads',
  filename: function(req, file, cb) {
    cb(null, file.originalname + '.jpg');
    //cb(null, file.originalname + '-' + Date.now() + '.jpg');
    /*return crypto.pseudoRandomBytes(16, function(err, raw) {
      if (err) {
        return cb(err);
      } 

    return cb(null, "" + (raw.toString('hex')) + (path.extname(file.originalname)));
    });  */
  }
});

app.post('/', multer({
  storage: storage
}).single('upload'), function(req, res) {
  console.log(req.file);
  
  ///// execute style transfer pipieline start////////
  var exec = require('child_process').exec;
  var execProcess = require("./exec_process.js");
  execProcess.result("expect do_pipeline_works.sh "+req.file.path+" /Users/guanjhensu/Desktop/ProjectArt/nodejs_assemble/public/", function(err, response){

      if(!err){
          console.log(response);
          var result = {
            status: 'ok'
          };
          res.writeHead(200, {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                });
          res.write(JSON.stringify(result));
          res.end();
      }else {
          console.log(err);
      }
  });
  /////////////////////////////////////////////////////
  
  
});


// response image to client
app.use(express.static(__dirname + '/public'));



