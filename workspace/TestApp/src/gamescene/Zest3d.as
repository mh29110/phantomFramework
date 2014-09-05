package gamescene
{
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    
    import io.plugin.core.graphics.Color;
    import io.plugin.math.algebra.APoint;
    
    import phantom.core.consts.ManagerName;
    import phantom.core.handlers.Handler;
    import phantom.core.managers.LoaderManager;
    import phantom.core.managers.ResLoader;
    
    import plugin.net.parsers.max3ds.ParserAdapter3DS;
    
    import zest3d.applications.Zest3DApplication;
    import zest3d.detail.BillboardNode;
    import zest3d.geometry.ParticleGeometry;
    import zest3d.geometry.SkyboxGeometry;
    import zest3d.localeffects.CartoonEffect;
    import zest3d.localeffects.TextureEffect;
    import zest3d.primitives.PlanePrimitive;
    import zest3d.resources.Texture2D;
    import zest3d.resources.TextureCube;
    import zest3d.scenegraph.Light;
    import zest3d.scenegraph.TriMesh;
    import zest3d.scenegraph.enum.LightType;
    import zest3d.scenegraph.enum.UpdateType;
    
    public class Zest3d extends Zest3DApplication
    {
		private var _dancer:TriMesh;
        private var _particles:ParticleGeometry;

        private var _loader:LoaderManager;
        override protected function initialize():void 
        {
			var app:AppCenter = AppCenter.instance;
			_loader = app.getManager(ManagerName.LOADER) as LoaderManager;
			_loader.loadAssets([{url:"assets/3ds/dancer.3ds",type:ResLoader.BYTE,size:100},{url:"assets/atf/toon_gradient2.atf",type:ResLoader.BYTE,size:100},{url:"assets/atf/bw_checked.atf",type:ResLoader.BYTE,size:100},{url:"assets/particle.atf",type:ResLoader.BYTE,size:100},{url:"assets/cove.atf",type:ResLoader.BYTE,size:50}],new Handler(onLoadedHandler));
			
        }
        
        override protected function update(appTime:Number):void 
        {
			if(_particles)
			{
	            _particles.rotationY = appTime * 0.001;
			}
        }
		
		private function onLoadedHandler():void
		{
			skybox = new SkyboxGeometry( TextureCube.fromByteArray( _loader.getResLoaded("assets/cove.atf") ) );
			camera.position = new APoint( 0, 0, -8 );
			
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
			_particles.scaleUniform = 15;
			scene.addChild( _particles );
			
			//billboard
			var checkedTexture:Texture2D = Texture2D.fromByteArray( _loader.getResLoaded("assets/atf/bw_checked.atf") );
			var texture2DEffect:TextureEffect = new TextureEffect( checkedTexture );
			var plane:PlanePrimitive = new PlanePrimitive( texture2DEffect, true, false );
			var billboard:BillboardNode = new BillboardNode( camera );
			billboard.addChild( plane );
			billboard.x = -5,billboard.y = -5;
			scene.addChild( billboard );
			
			//3d model
			var parser:ParserAdapter3DS = new ParserAdapter3DS( _loader.getResLoaded("assets/3ds/dancer.3ds"), true, true );
			parser.parse();
			
			var gradientTexture: Texture2D = Texture2D.fromByteArray( _loader.getResLoaded("assets/atf/toon_gradient2.atf") );
//			var checkedTexture:Texture2D = Texture2D.fromByteArray( _loader.getResLoaded("assets/atf/bw_checked.atf") );
			
			var light:Light = new Light( LightType.POINT );
			light.position = new APoint( 1, -10, -5 );
			light.ambient = new Color( 0.1, 0.1, 0.1 );
			light.specular = new Color( 0.9, 0.9, 0.9, 50 );
			
			var cartoonEffect:CartoonEffect = new CartoonEffect( checkedTexture, gradientTexture, light );
			_dancer = parser.getMeshAt( 0 );
			_dancer.updateModelSpace( UpdateType.NORMALS );
			_dancer.effect = cartoonEffect;
			_dancer.rotationX = 90 * (Math.PI / 180);
			_dancer.scaleUniform = 8;
			_dancer.y = 3;
			
			scene.addChild( _dancer );
		}
    }
}