package com.element.oimo.ext.oimo
{
	import com.element.oimo.physics.collision.shape.BoxShape;
	import com.element.oimo.physics.collision.shape.CylinderShape;
	import com.element.oimo.physics.collision.shape.ShapeConfig;
	import com.element.oimo.physics.collision.shape.SphereShape;
	import com.element.oimo.physics.dynamics.RigidBody;
	import com.element.oimo.physics.dynamics.World;
	
	import io.plugin.math.algebra.APoint;
	import io.plugin.math.algebra.HMatrix;
	
	import zest3d.primitives.CubePrimitive;
	import zest3d.primitives.CylinderPrimitive;
	import zest3d.primitives.SpherePrimitive;
	import zest3d.scenegraph.Spatial;
	
	public class OimoWorld
	{
		public var world:World;
		protected var _spatialList:Vector.<OimoSpatial3D>;
		
		public function OimoWorld(stepPerSecound:Number = 30)
		{
			world = new World(stepPerSecound);
			_spatialList = new Vector.<OimoSpatial3D>();
		}
		
		private function addChild(oimoSpatial3D:OimoSpatial3D):void
		{
			_spatialList.push(oimoSpatial3D);
			world.addRigidBody(oimoSpatial3D.rigidBody);
		}
		
		public function step():void
		{
			var r:RigidBody;
			var spatial:Spatial;
			for each( var i:OimoSpatial3D in _spatialList )
			{
				r = i.rigidBody;
				spatial = i.spatial;
				
				//TODO pool these objects
				var translate:APoint = new APoint();
				var rotate:HMatrix = new HMatrix();
				
				rotate.m00 = r.rotation.e00;
				rotate.m01 = r.rotation.e01;
				rotate.m02 = r.rotation.e02;
				
				rotate.m10 = r.rotation.e10;
				rotate.m11 = r.rotation.e11;
				rotate.m12 = r.rotation.e12;
				
				rotate.m20 = r.rotation.e20;
				rotate.m21 = r.rotation.e21;
				rotate.m22 = r.rotation.e22;
				
				translate.x = r.position.x;
				translate.y = r.position.y;
				translate.z = r.position.z;
				
				spatial.localTransform.rotate = rotate;
				spatial.localTransform.translate = translate;
			}
			world.step();
		}
		
		public function addCylinder( cylinder:CylinderPrimitive, radius:Number, height:Number, rigidBodyType: uint = 0x0 ):void
		{
			var cylinderConfig:ShapeConfig = new ShapeConfig();
			cylinderConfig.position.init( cylinder.x, cylinder.y, cylinder.z );
			
			cylinderConfig.rotation = cylinderConfig.rotation.mulRotate( cylinderConfig.rotation, 90 * (Math.PI / 180), 1, 0, 0 ); // make the Zest3D and Oimo cylinders orientation the same.
			
			var cylinderShape:CylinderShape = new CylinderShape( 1, 2, cylinderConfig );
			var cylinderMesh3D:OimoSpatial3D = new OimoSpatial3D( cylinderShape, cylinder as Spatial, rigidBodyType );
			cylinderMesh3D.friction = 1.5;
			cylinderMesh3D.restitution = 0.5;
			addChild( cylinderMesh3D );
		}
		
		public function addSphere( sphere:SpherePrimitive, radius:Number, rigidBodyType: uint = 0x0 ):void
		{
			var sphereConfig:ShapeConfig = new ShapeConfig();
			sphereConfig.position.init( sphere.x, sphere.y, sphere.z );
			var sphereShape:SphereShape = new SphereShape( 1, sphereConfig );
			var sphereMesh3D:OimoSpatial3D = new OimoSpatial3D( sphereShape, sphere as Spatial, rigidBodyType );
			
			sphereMesh3D.friction = 1.5;
			sphereMesh3D.restitution = 0.5;
			addChild( sphereMesh3D );
		}
		
		public function addCube( cube:CubePrimitive, xExtent:Number, yExtent:Number, zExtent:Number, rigidBodyType: uint = 0x0 ):void
		{
			var cubeConfig:ShapeConfig = new ShapeConfig();
			cubeConfig.position.init( cube.x, cube.y, cube.z );
			var boxShape:BoxShape = new BoxShape( xExtent * 2, yExtent * 2, zExtent * 2, cubeConfig );
			
			var boxMesh3D:OimoSpatial3D = new OimoSpatial3D( boxShape, cube as Spatial, rigidBodyType );
			boxMesh3D.friction = 1.5;
			boxMesh3D.restitution = 0.5;
			
			addChild( boxMesh3D );
		}
		
	}
}