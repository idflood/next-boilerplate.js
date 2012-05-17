define [
  'use!Underscore',
  'use!Backbone',
  'jquery',
  'libs/namespace',
  'cs!core/utils/AutoReload',
  'order!libs/three.js/build/Three',
  'order!libs/three.js/examples/js/postprocessing/EffectComposer',
  'order!libs/three.js/examples/js/postprocessing/RenderPass',
  'order!libs/three.js/examples/js/postprocessing/BloomPass',
  'order!libs/three.js/examples/js/postprocessing/FilmPass',
  'order!libs/three.js/examples/js/postprocessing/TexturePass',
  'order!libs/three.js/examples/js/postprocessing/ShaderPass',
  'order!libs/three.js/examples/js/postprocessing/MaskPass',
  'order!libs/three.js/examples/js/ShaderExtras',
], (_, Backbone) ->
  #### App
  
  namespace "Next",
    ThreeApp: class ThreeApp
      constructor: () ->
        @preInit()
        @onResize()
        @animate()
      
      preInit: () =>
        # Setup autoreload on source change
        new Next.AutoReload()
        
        # Setup some other variables
        @clock = new THREE.Clock()
        @scene = new THREE.Scene()
        
        @createCamera()
        @createLights()
        @createWorld()
        @createRenderer()
        
        $(window).bind "resize", (e) => @onResize()
      
      createRenderer: () =>
        # Create html container
        $("body").append("<div id='container'></div>")
        @container = $("#container")[0]
        
        # Create a webgl renderer
        @renderer = new THREE.WebGLRenderer( { clearColor: Next.settings.backgroundColor, clearAlpha: 1, antialias: false } )
        @renderer.setSize( window.innerWidth, window.innerHeight )
        @renderer.autoClear = false
        
        # Add the renderer to the dom
        @container.appendChild( @renderer.domElement )
        
        if Next.settings.postprocessing == true
          @renderModel = new THREE.RenderPass(@scene, @camera)
          @effectBloom = new THREE.BloomPass(0.5)
          @effectFilm = new THREE.FilmPass(0.15, 0.025, 648, false)
          @effectVignette = new THREE.ShaderPass( THREE.ShaderExtras[ "vignette" ] )
          @effectVignette.uniforms['darkness'].value = 0.7
                    
          @composer = new THREE.EffectComposer( @renderer )
          @composer.addPass( @renderModel )
          @composer.addPass( @effectBloom )
          @composer.addPass( @effectFilm )
          @composer.addPass( @effectVignette )
          
          # make the last pass render to screen so that we can see something
          @effectVignette.renderToScreen = true
      
      createLights: () =>
        @directionalLight = new THREE.DirectionalLight( 0xffffff, 1.15 )
        @directionalLight.position.set( 500, 1000, 0 )
        @scene.add( @directionalLight )
      
      createCamera: () =>
        @camera = new THREE.PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 1, 20000 )
        @scene.add( @camera )
      
      # Needs to be overriden
      createWorld: () => return false
      updateWorld: () => return false
      
      animate: () =>
        delta = @clock.getDelta()
        time = @clock.getElapsedTime() * 10
        
        requestAnimationFrame( @animate )
        @updateWorld(time, delta)
        @render(time, delta)
      
      render: (time, delta) =>
        @renderer.clear()
        
        if @composer
          @composer.render(delta)
        else
          @renderer.render(@scene, @camera)
      
      onResize: () =>
        @camera.aspect = window.innerWidth / window.innerHeight
        @camera.updateProjectionMatrix()
        
        @renderer.setSize( window.innerWidth, window.innerHeight )
        if @composer
          @composer.reset()
      
