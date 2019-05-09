// To parse this data:
//
const fs = require('fs');

var countries = require('./CountryCodes.json');
var native = require('./countries.json');

countries.forEach(cc => {
    
    try {
        cc["native"] = native[cc.code].native
      }
      catch (e) {
        cc["native"] = cc.name
      }
});
var json = JSON.stringify(countries);

fs.writeFile("./file.json", json, function(err) {
    if(err) {
        return console.log(err);
    }

    console.log("The file was saved!");
}); 
