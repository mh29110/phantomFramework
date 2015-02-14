package plugin.net.parsers.max3ds.types 
{
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class Mesh3DS 
	{
		
		public static const PLANAR_MAP: int = 0;
		public static const CYLINDRICAL_MAP: int = 1;
		public static const SPHERICAL_MAP: int = 2;
		
		public var name: String = "";
		public var vertices: Vector.<Vertex3DS> = new Vector.<Vertex3DS>();
		public var texCoords: Vector.<TexCoords3DS> = new Vector.<TexCoords3DS>();
		public var texUTile: Number = 0;
		public var texVTile: Number = 0;
		public var texMapType: int = 0;
		public var faces: Vector.<Face3DS> = new Vector.<Face3DS>();
		public var smoothGroup: Vector.<int> = new Vector.<int>();
		public var localSystem: Array = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0],[0, 0, 0, 0]];
		public var faceMaterials: Vector.<FaceMaterial3DS> = new Vector.<FaceMaterial3DS>( ); // TODO check this out multi-dim
		
		public var nodeId: int = 0;
		public var parentNodeId: int = 0;
		public var nodeFlags: int = 0;
		public var pivot: Vertex3DS = new Vertex3DS();
		public var positionTrack: XYZTrack3DS = new XYZTrack3DS();
		public var rotationTrack: RotationTrack3DS = new RotationTrack3DS();
		public var scaleTrack: XYZTrack3DS = new XYZTrack3DS();
		public var morphTrack: MorphTrack3DS = new MorphTrack3DS();
		public var hideTrack: HideTrack3DS = new HideTrack3DS();
		
		
		public function Mesh3DS() 
		{
		}
		
		public function addFaceMaterial( m: FaceMaterial3DS ): void
		{
			faceMaterials.push( m );
		}
		
		public function get numFaces(): int
		{
			return faces.length;
		}
		
		public function get numVertices(): int
		{
			return vertices.length;
		}
		
		public function get numIndices(): int
		{
			return numFaces * 3;
		}
		
	}

}