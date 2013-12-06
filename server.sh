#!/bin/sh

# compile the coffeescript files in this project
./node_modules/.bin/coffee --watch --compile -o www/js ./coffee/ &

# compile the coffeescript files in celestrium
./node_modules/.bin/coffee --watch --compile -o www/js ./celestrium/core-coffee/ &

# statically serve files out of ./www/
node app.js
