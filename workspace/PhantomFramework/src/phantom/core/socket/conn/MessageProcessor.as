package phantom.core.socket.conn
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import phantom.core.interfaces.conn.IProtocol;

public class MessageProcessor
{
	/**消息ID描述的长度(一个ushort)*/
	private static const MESSAGE_ID_LENGTH:uint = 2;
	private static const BYTEARRAY_PARAM:String = "byteArray";
	private var _connectionType:uint = 0;
	private var _type:String = "";
	/**
	 * 消息
	 */	
	private var _message:IProtocol;
	public function MessageProcessor()
	{
	}
	/**
	 * 消息
	 */
	public function set message(value:IProtocol):void
	{
		this._message = value;
	}
	public function get message():IProtocol
	{
		return this._message;
	}
	/**
	 * 返回ByteArray
	 */
	public function get data():*
	{
		switch(this._type)
		{
			case MessageDataType.SOCKET:
				//消息前包个short头
				var data:ByteArray = this._message.toBytes();
				var bytes:ByteArray = new ByteArray();
				bytes.endian = Endian.LITTLE_ENDIAN;// todo
				bytes.writeShort(data.length + MESSAGE_ID_LENGTH);
				bytes.writeShort(this._message.getID());
				bytes.writeBytes(data);
				return bytes;
				break;
			case MessageDataType.HTTP:
				break;
		}
	}
	/**
	 * 数据类型,决定data属性获得的最终类型
	 */	
	public function set type(value:String):void
	{
		this._type = value;
	}
	public function get type():String
	{
		return this._type;
	}
}
}