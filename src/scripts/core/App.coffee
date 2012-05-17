define [
  'use!Underscore',
  'use!Backbone',
  'jquery',
  'libs/namespace',
  'cs!core/utils/ThreeApp',
], (_, Backbone) ->
  #### App
  
  namespace "Next",
    settings:
      postprocessing: true
      backgroundColor: 0x446699
    
    App: class App extends Next.ThreeApp
      constructor: () ->
        super
        
        @camera.position.set(200, 150, 400)
        @camera.lookAt(new THREE.Vector3(0,40,0))
        
      createWorld: () =>
        # create some cubes
        cubeWidth = 100
        @materialCube = new THREE.MeshPhongMaterial( { color: 0xff7722 } )
        @cube = new THREE.CubeGeometry( cubeWidth, cubeWidth, cubeWidth )
        @object = new THREE.Mesh( @cube, @materialCube )
        @object.position.y = 70
        @scene.add(@object)
        
        # Create a ground
        @materialPlane = new THREE.MeshLambertMaterial( { color: 0xffffff } )
        @plane = new THREE.PlaneGeometry( 10000, 10000, 10, 10 )
        ground = new THREE.Mesh( @plane, @materialPlane )
        @scene.add(ground)
      
      updateWorld: (time, delta) =>
        @object.rotation.y = time * 0.1
