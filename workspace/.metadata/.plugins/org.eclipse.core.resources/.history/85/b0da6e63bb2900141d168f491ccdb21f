package com.core.network
{
	import flash.events.Event;
	import flash.utils.Endian;

	/**
	 * 通讯数据包 
	 */
	public class DataBlock extends Event
	{
		/**
		 * 命令ID
		 */
		public var Ident: uint;
		/**
		 * 数据内容
		 */
		public var Data:MyByteArray;

		public function DataBlock( ident:uint, data:MyByteArray = null )
		{
			super( ident.toString());
			Ident = ident;

			if ( data!=null )
			{
				this.Data = data;
			}
			else
			{
				this.Data = new MyByteArray();

				this.Data.endian = Endian.LITTLE_ENDIAN;
			}
		}
	}
}
