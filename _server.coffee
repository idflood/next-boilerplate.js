# Require node modules
sys = require("util")
fs = require("fs")
spawn = require("child_process").spawn
path = require("path")
url = require("url")
exec = require("child_process").exec
watch = require("watch")
express = require("express")
coffee = require("coffee-script")
stylus = require("stylus")
jade = require("jade")
nib = require("nib")
wrench = require("wrench")
requirejs = require('requirejs')

# Check for "build" parameter
is_build = (process.argv[2] == "build")

# Utility functions
delay = (ms, func) -> setTimeout func, ms
exec_and_log = (command, on_complete = null) ->
  console.log "executing command: " + command
  exec command, (err, stdout, stderr) ->
    if err
      console.log "error: " + err
    console.log stdout + stderr
    if on_complete then delay 50, () => on_complete()
    
# Require coffeescript and jade to be installed globally for building the static_output
if is_build
  copyFileSync = (srcFile, destFile) ->
    BUF_LENGTH = 64*1024
    buff = new Buffer(BUF_LENGTH)
    fdr = fs.openSync(srcFile, 'r')
    fdw = fs.openSync(destFile, 'w')
    bytesRead = 1
    pos = 0
    while bytesRead > 0
      bytesRead = fs.readSync(fdr, buff, 0, BUF_LENGTH, pos)
      fs.writeSync(fdw,buff,0,bytesRead)
      pos += bytesRead
    fs.closeSync(fdr)
    fs.closeSync(fdw)
  compile_jade = (filename) ->
    html = jade.compile(fs.readFileSync('views/' + filename + ".jade", 'utf8'), {pretty: true})
    if html
      fs.writeFileSync('output_static/' + filename + ".html", html())
    else
      console.log "Can't compile: views/" + filename + ".jade"
  console.log "Building..."
  
  # Remove previous build
  wrench.rmdirSyncRecursive('output_static', true)
  # Create root directory
  wrench.mkdirSyncRecursive('output_static/scripts', parseInt('777', 8))
  # Copy public assets
  #wrench.copyDirSyncRecursive('public/assets', 'output_static/assets')
  #wrench.copyDirSyncRecursive('public/examples', 'output_static/examples')
  wrench.copyDirSyncRecursive('src/scripts/libs', 'output_static/scripts/libs')
  
  # copy test, require-config and boot file (js)
  copyFileSync("src/scripts/boot.js", "output_static/scripts/boot.js")
  copyFileSync("src/scripts/boot_test.js", "output_static/scripts/boot_test.js")
  copyFileSync("src/scripts/require-config.js", "output_static/scripts/require-config.js")
  
  # Copy the development css to the output_static dir
  # todo: use the node.js stylus module with compress option
  wrench.copyDirSyncRecursive('public/stylesheets', 'output_static/stylesheets')
  
  # Compile jade to html
  console.log "Compiling jade files..."
  compile_jade("index")
  compile_jade("test")
  
  console.log "Starting to optimize the javascripts..."
  # Optimize the js
  config =
    baseUrl: 'src/scripts/'
    mainConfigFile: 'src/scripts/require-config.js'
    optimize: 'none'
    name: 'boot'
    out: 'output_static/scripts/boot.js'
    pragmasOnSave:
      excludeCoffeeScript: true

  requirejs.optimize config, (buildResponse) ->
    # Done
    console.log "Optimization complete!"
    console.log "ThreeNodes.js has successfuly been compiled to /output_static !"
    process.exit()

else
  # development environment
  
  # Setup express server
  app = express.createServer()
  port = process.env.PORT || 3000
  app.use app.router
  app.use express.methodOverride()
  app.use express.bodyParser()
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  
  # Configure the stylus middleware (.styl -> .css)
  app.use stylus.middleware(
    src: __dirname + "/src"
    dest: __dirname + "/public"
    compile: (str, path) ->
      stylus(str).set("filename", path).set("warn", true).set("compress", false).set("paths", [ require("stylus-blueprint") ]).use nib()
  )
  # Configure static assets
  app.use express.static(__dirname + "/public")
  
  # Serve on the fly compiled js or existing js if there is no .coffee
  app.get "/scripts/*.coffee", (req, res) ->
    file = req.params[0]
    return_static = () ->
      path.exists "src/scripts/" + file + ".coffee", (exists) ->
        if exists
          res.header("Content-Type", "application/x-javascript")
          cs = fs.readFileSync("src/scripts/" + file + ".coffee", "utf8")
          res.send(cs)
        else
          # attempt to serve test file before doing a 404
          path.exists file + ".coffee", (exists) ->
            if exists
              res.header("Content-Type", "application/x-javascript")
              cs = fs.readFileSync(file + ".coffee", "utf8")
              res.send(cs)
            else
              res.send("Cannot GET " + "src/scripts/" + file + ".coffee", 404)
    
    return_static()
  
  app.get "/scripts/*.js", (req, res) ->
    file = req.params[0]
    
    return_static = () ->
      path.exists "src/scripts/" + file + ".js", (exists) ->
        if exists
          res.header("Content-Type", "application/x-javascript")
          cs = fs.readFileSync("src/scripts/" + file + ".js", "utf8")
          res.send(cs)
        else
          res.send("Cannot GET " + "/scripts/" + file + ".js", 404)
    
    return_static()
  
  # Setup html routes
  app.get "/", (req, res) ->
    res.render "index",
      layout: false
  
  app.get "/test", (req, res) ->
    res.render "test",
      layout: false
  
  # Start the server
  app.listen port
  console.log "###################################################"
  console.log ""
  console.log "Ready!"
  console.log ""
  console.log "Tests available at:"
  console.log "http://localhost:#{port}/test"
  console.log ""
  console.log "Main url:"
  console.log "http://localhost:#{port}/"
