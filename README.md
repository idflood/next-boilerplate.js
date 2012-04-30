## Installation
1. git clone git://github.com/idflood/next-boilerplate.js.git
2. cd next-boilerplate.js
3. npm install -d

## Usage
1. cd next-boilerplate.js
2. node server.js
3. go to http://localhost:3000/
4. tests are located at http://localhost:3000/test

## Continuous testing
1. Install phantomjs: http://phantomjs.org/
2. cd next-boilerplate.js
3. node server.js test
4. Tests are automatically run when a source file change, results are displayed in the terminal. You can still access the app with the previous url while tests are running.

## Build / Deploy
1. cd next-boilerplate.js
2. node server.js build
3. a new /output_static should have been created
