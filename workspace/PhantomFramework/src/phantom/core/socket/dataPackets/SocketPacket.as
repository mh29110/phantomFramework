package phantom.core.socket.dataPackets
{
	import flash.utils.ByteArray;
	
	import phantom.core.interfaces.conn.IProtocol;
	
	public class SocketPacket implements IProtocol
	{
		public var type:int = 1;
		public var id:int;
		public var name:String;
		public function SocketPacket()
		{
		}
		
		public function init(data:ByteArray):void
		{
			id = data.readInt();
			name = data.readUTF();
		}
		
		public function toBytes():ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.writeInt(type);
			return ba;
		}
		
		public function getID():uint
		{
			return id;
		}
	}
}