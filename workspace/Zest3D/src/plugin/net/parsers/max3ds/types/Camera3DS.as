package plugin.net.parsers.max3ds.types 
{
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class Camera3DS 
	{
		
		public var name: String = "";
		public var position: Vertex3DS = new Vertex3DS( 1, 0, 0 );
		public var target: Vertex3DS = new Vertex3DS( 0, 0, 0 );
		public var roll: Number = 0;
		public var lens: Number = 0;
		public var nearPlane: Number = 0;
		public var farPlane: Number = 0;
		
		public var targetNodeId: int = 0;
		public var targetParentNodeId: int = 0;
		public var targetNodeFlags: int = 0;
		public var positionNodeId: int = 0;
		public var positionParentNodeId: int = 0;
		public var positionNodeFlags: int = 0;
		public var positionTrack: XYZTrack3DS = new XYZTrack3DS();
		public var targetTrack: XYZTrack3DS = new XYZTrack3DS();
		public var fovTrack: PTrack3DS = new PTrack3DS();
		public var rollTrack: PTrack3DS = new PTrack3DS();
		
		public function Camera3DS() 
		{
		}
		
	}

}