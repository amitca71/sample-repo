#!/usr/bin/env bash
#get version update_type argument (default=patch)
version_update_type=${1:-patch}
pid=$$
#in case of error log the errors to temp file
npm_info=$(npm info --json 2>/tmp/err${pid})
if [ $? -ne 0 ]; then
    #checks if the error was because there is no such npm registry
    grep "is not in the npm registry" /tmp/err${pid}
    if [ $? -eq 0 ]; then
        echo "the package is not yet published to npm, no need to update lates version"
        exit 0
    else
        echo "error retrieving version from node. if its because the package is not published yet so its file, else need to check"
        exit 1
    fi
fi
export NPM_INF=$npm_info
#backup original package.json before replacing
cp package.json /tmp/package.json_${pid}
jsonFile="package.json"
export JSON_FILE=$jsonFile
node <<EOF
//Read orig file
var data = require('./${jsonFile}');
var fs = require('fs');
//get the repository info
var npm_info=JSON.parse(process.env.NPM_INF);
//var fileName='package.json'
var fileName=process.env.JSON_FILE
//get versions list from npm_info
var versions=npm_info['versions'];
//assign latest version to new file
data.version=versions[versions.length-1];
//Output data
fs.writeFile(fileName, JSON.stringify(data, null, 2), function writeJSON(err) {
  if (err) return console.log(err);
  console.log(JSON.stringify(data));
  console.log('writing to ' + fileName);
});
EOF
#update the version in package.json using the npm version command
npm version $version_update_type
if [ $? -ne 0 ]; then
    echo "failed to update version on package.json"
    exit 1
fi
echo "finished succesfully"
exit 0
