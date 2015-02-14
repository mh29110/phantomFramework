package plugin.net.parsers.max3ds 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import plugin.net.parsers.max3ds.types.Scene3DS;
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class ParserMax3DS
	{
		
		protected var _scene: Scene3DS;
		protected var _data: ByteArray;
		
		public function ParserMax3DS( data: ByteArray ) 
		{
			_data = data;
			_data.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function parse(): void
		{
			_scene = new Scene3DS( _data );
		}
		
		[Inline]
		public final function get scene():Scene3DS 
		{
			return _scene;
		}
		
	}

}