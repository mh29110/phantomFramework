package plugin.net.parsers.max3ds.types 
{
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class Track3DS 
	{
		
		public static const SINGLE: int = 0;
		public static const REPEAT: int = 2;
		public static const LOOP: int = 3;
		
		public static const LOCK_X: int = 0x008;
		public static const LOCK_Y: int = 0x010;
		public static const LOCK_Z: int = 0x020;
		
		public static const UNLINK_X: int = 0x080;
		public static const UNLINK_Y: int = 0x100;
		public static const UNLINK__Z: int = 0x200;
		
		public var flags: int = 0;
		
		public function Track3DS() 
		{
		}
		
		public function get loopType(): int
		{
			return ( flags & 0x3 );
		}
		
	}

}