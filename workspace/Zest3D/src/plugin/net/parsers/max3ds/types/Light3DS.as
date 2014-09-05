package plugin.net.parsers.max3ds.types 
{
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class Light3DS 
	{
		
		public var name: String = "";
		public var off: Boolean = false;
		public var position: Vertex3DS = new Vertex3DS( 1, 0, 0 );
		public var target: Vertex3DS = new Vertex3DS( 0, 0, 0 );
		public var color: Color3DS = new Color3DS();
		public var hotspot: Number = 0;
		public var falloff: Number = 0;
		public var outerRange: Number = 0;
		public var innerRange: Number = 0;
		public var multiplexer: Number = 0;
		public var attenuation: Number = 0;
		public var roll: Number = 0;
		public var shadowed: Boolean = false;
		public var shadowBias: Number = 0;
		public var shadowFilter: Number = 0;
		public var shadowSize: Number = 0;
		public var cone: Boolean = false;
		public var rectangular: Boolean = false;
		public var aspect: Number = 0;
		public var projector: Boolean = false;
		public var projectorName: String = "";
		public var overshoot: Boolean = false;
		public var rayBias: Number = 0;
		public var rayShadows: Boolean = false;
		
		public function Light3DS() 
		{
		}
		
	}

}