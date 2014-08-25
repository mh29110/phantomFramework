package phantom.core.socket.dataPackets
{
	import flash.utils.ByteArray;
	
	import phantom.core.interfaces.conn.IProtocol;
	
	public class SocketPacket implements IProtocol
	{
		private var _type:int = 1;
		private var _id:int ;
		private var _name:String;
		public function SocketPacket()
		{
		}
		
		public function init(data:ByteArray):void
		{
			_id = data.readInt();
			_name = data.readUTF();
		}
		
		public function toBytes():ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.writeInt(_type);
			return ba;
		}
		
		public function getID():uint
		{
			return _type;
		}
	}
}