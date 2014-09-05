package gamescene
{
    import com.element.oimo.ext.oimo.helpers.Zest3DOimoWorld;
    import com.element.oimo.physics.dynamics.RigidBody;
    
    import flash.utils.ByteArray;
    
    import io.plugin.core.graphics.Color;
    import io.plugin.math.algebra.APoint;
    import io.plugin.math.algebra.AVector;
    import io.plugin.math.algebra.HMatrix;
    import io.plugin.math.algebra.HQuaternion;
    
    import phantom.core.consts.ManagerName;
    import phantom.core.managers.LoaderManager;
    
    import plugin.net.parsers.max3ds.ParserAdapter3DS;
    
    import zest3d.applications.Zest3DApplication;
    import zest3d.controllers.KeyframeController;
    import zest3d.controllers.enum.RepeatType;
    import zest3d.datatypes.Transform;
    import zest3d.geometry.ParticleGeometry;
    import zest3d.geometry.SkyboxGeometry;
    import zest3d.localeffects.CartoonEffect;
    import zest3d.localeffects.PhongEffect;
    import zest3d.localeffects.TextureEffect;
    import zest3d.primitives.CubePrimitive;
    import zest3d.primitives.CylinderPrimitive;
    import zest3d.primitives.SpherePrimitive;
    import zest3d.resources.Texture2D;
    import zest3d.resources.TextureCube;
    import zest3d.scenegraph.Light;
    import zest3d.scenegraph.TriMesh;
    import zest3d.scenegraph.enum.CullingType;
    import zest3d.scenegraph.enum.LightType;
    import zest3d.scenegraph.enum.UpdateType;
    
    public class Zest3d extends Zest3DApplication
    {
		private var _dancer:TriMesh;
        private var _particles:ParticleGeometry;

        private var _oimoWorld:Zest3DOimoWorld;

        private var _loader:LoaderManager;

        private var _light:Light;

        override protected function initialize():void 
        {
			_loader = AppCenter.instance.getManager(ManagerName.LOADER) as LoaderManager;
			initScene();
			initOther();
        }
		
        override protected function update(appTime:Number):void 
        {
			if(_particles)
			{
	            _particles.rotationY = appTime * 0.001;
			}
			if(_oimoWorld)
			{
				_oimoWorld.step();
			}
        }
		
		private function initScene():void
		{
			skybox = new SkyboxGeometry( TextureCube.fromByteArray( _loader.getResLoaded("assets/atfcube/skybox.atf") ) );
			camera.position = new APoint( 0, -5, -8 );
			
			initLight();
			
			initOimoWorld();
			
			init3DModels();
		}
		
		private function initOimoWorld():void
		{
			// Oimo
			_oimoWorld = new Zest3DOimoWorld( 30 );
			
			
			// Add Spheres
			var spaceTexture:Texture2D = Texture2D.fromByteArray( _loader.getResLoaded("assets/atf/space.atf") );
			var spaceEffect:PhongEffect = new PhongEffect( spaceTexture, _light );
			
			var i:int;
			for ( i = 0; i < 100; ++i )
			{
				var sphere:SpherePrimitive = new SpherePrimitive( spaceEffect, true, true, false, false, 16, 16, 1, false, false );
				sphere.translate( (Math.random() * 10) - 5, ( -Math.random() * 1500) - 5, (Math.random() * 10) - 5 );
				scene.addChild( sphere );
				_oimoWorld.addSphere( sphere, 1 );
			}
			
			// Add Cylinders
			for ( i = 0; i < 100; ++i )
			{
				var cylinder:CylinderPrimitive = new CylinderPrimitive( spaceEffect, true, true, false, false, 4, 16, 1, 2, false, false, false );
				cylinder.translate( (Math.random() * 10) - 5, ( -Math.random() * 1500) - 5, (Math.random() * 10) - 5 );
				scene.addChild( cylinder );
				_oimoWorld.addCylinder( cylinder, 1, 2 );
			}
			
			// Add Ground
			var plane:CubePrimitive = new CubePrimitive( spaceEffect, true, true, false, false, 10, 10, 10 );
			plane.translate( 0, 10, 0 );
			plane.culling = CullingType.NEVER;
			_oimoWorld.addCube( plane, 10, 10, 10, RigidBody.BODY_STATIC );
			scene.addChild( plane );
		}
		
		private function initLight():void
		{
			_light = new Light( LightType.POINT );
			_light.position = new APoint( 0, -10, -8 );
			_light.ambient = new Color( 0.1, 0.1, 0.1 );
			_light.specular = new Color( 0.9, 0.9, 0.9, 50 );
			//			light.exponent = 6;
		}
		
		private function init3DModels():void
		{
			//3d model
			var parser:ParserAdapter3DS = new ParserAdapter3DS( _loader.getResLoaded("assets/3ds/dancer.3ds"), true, true );
			parser.parse();
			
			var gradientTexture: Texture2D = Texture2D.fromByteArray( _loader.getResLoaded("assets/atf/toon_gradient2.atf") );
			//			var checkedTexture:Texture2D = Texture2D.fromByteArray( _loader.getResLoaded("assets/atf/bw_checked.atf") );
			
			var checkedTexture:Texture2D = Texture2D.fromByteArray( _loader.getResLoaded("assets/atf/bw_checked.atf") );
			var cartoonEffect:CartoonEffect = new CartoonEffect( checkedTexture, gradientTexture, _light );
			_dancer = parser.getMeshAt( 0 );
			_dancer.updateModelSpace( UpdateType.NORMALS );
			_dancer.effect = cartoonEffect;
			_dancer.rotationX = 90 * (Math.PI / 180);
			_dancer.rotationZ = 180 * (Math.PI / 180);
			_dancer.scaleUniform = 15;
			
			var _keyframeController:KeyframeController = new KeyframeController( 0, 3, 4, 4, new Transform() );
			_keyframeController.minTime = 0;
			_keyframeController.maxTime = 9000;
			_keyframeController.repeat = RepeatType.WRAP;
			
			// rotations
			var m0:HMatrix = new HMatrix().rotation( AVector.UNIT_Z, (Math.PI / 180) * 90);
			var m1:HMatrix = new HMatrix().rotation( AVector.UNIT_Y, (Math.PI / 180) * 180);
			var m2:HMatrix = new HMatrix().rotation( AVector.UNIT_X, (Math.PI / 180) * 180);
			var m3:HMatrix = new HMatrix().rotation( AVector.UNIT_Y, (Math.PI / 180) * 90);
			_keyframeController.rotations[0] = HQuaternion.fromRotationMatrix( m0 );
			_keyframeController.rotations[1] = HQuaternion.fromRotationMatrix( m1 );
			_keyframeController.rotations[2] = HQuaternion.fromRotationMatrix( m2 );
			_keyframeController.rotations[3] = HQuaternion.fromRotationMatrix( m3 );
			_keyframeController.rotationTimes[0] = 0;
			_keyframeController.rotationTimes[1] = 3000;
			_keyframeController.rotationTimes[2] = 6000;
			_keyframeController.rotationTimes[3] = 9000;
			
			// scales
			_keyframeController.scales[0] = 0.5;
			_keyframeController.scales[1] = 0.1;
			_keyframeController.scales[2] = 2;
			_keyframeController.scales[3] = 1;
			_keyframeController.scaleTimes[0] = 0;
			_keyframeController.scaleTimes[1] = 3000;
			_keyframeController.scaleTimes[2] = 6000;
			_keyframeController.scaleTimes[3] = 9000;
			
			//translations
			_keyframeController.translations[0] = new APoint( -5, -2, 0 );
			_keyframeController.translations[1] = new APoint(  2, -2, 0 );
			_keyframeController.translations[2] = new APoint(  2,  2, 2 );
			_keyframeController.translationTimes[0] = 0;
			_keyframeController.translationTimes[1] = 4500;
			_keyframeController.translationTimes[2] = 9000;
			
			_dancer.addController( _keyframeController );
			
			scene.addChild( _dancer );
		}
		
		/// off time example place
		private function initOther():void
		{
			//particle
			var particleTexture:Texture2D = Texture2D.fromByteArray( _loader.getResLoaded("assets/particle.atf") );
			var particleEffect:TextureEffect = new TextureEffect( particleTexture );
			
			var numParticles:int = 1000;
			var positionSizes:ByteArray = new ByteArray();
			for ( var i:Number = 0; i < numParticles; ++i )
			{
				positionSizes.writeFloat( (Math.random()-0.5) ); //x
				positionSizes.writeFloat( (Math.random()-0.5) ); //y
				positionSizes.writeFloat( (Math.random()-0.5) ); //z
				positionSizes.writeFloat( (Math.random() * 1) ); // scaler
			}
			_particles = new ParticleGeometry( particleEffect, numParticles, positionSizes );
			_particles.scaleUniform = 25;
			scene.addChild( _particles );
			
			//billboard
			//			var texture2DEffect:TextureEffect = new TextureEffect( checkedTexture );
			//			var plane:PlanePrimitive = new PlanePrimitive( texture2DEffect, true, false );
			//			var billboard:BillboardNode = new BillboardNode( camera );
			//			billboard.addChild( plane );
			//			billboard.x = -5,billboard.y = -5;
			//			scene.addChild( billboard );
		}
		
    }
}