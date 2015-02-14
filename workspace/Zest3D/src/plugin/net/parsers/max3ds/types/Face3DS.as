package plugin.net.parsers.max3ds.types 
{
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class Face3DS 
	{
		
		public static const AB_VISIBLE: int = 0x04;
		public static const BC_VISIBLE: int = 0x02;
		public static const CA_VISIBLE: int = 0x01;
		public static const U_WRAP: int = 0x08;
		public static const V_WRAP: int = 0x10;
		
		public var p0: int = 0;
		public var p1: int = 0;
		public var p2: int = 0;
		
		public var flags: int = 0;
		
		public function Face3DS( p0: int, p1: int, p2: int, flags: int ) 
		{
			this.p0 = p0;
			this.p1 = p1;
			this.p2 = p2;
			this.flags = flags;
		}
		
	}

}