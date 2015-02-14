package phantom.core.socket
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.Endian;


/**
 * 连接关闭
 */
[Event(name="connection_close",type="org.breeze.net.event.ConnectionEvent")]
/**
 * 接收到完整数据包
 */
[Event(name="connection_data",type="org.breeze.net.event.ConnectionEvent")]
/**
 * 连接成功
 */
[Event(name="connection_connected",type="org.breeze.net.event.ConnectionEvent")]
/**
 * 接收到残废的数据
 */
[Event(name="connection_invaild_data",type="org.breeze.net.event.ConnectionEvent")]
public class SocketProxy extends EventDispatcher
{
	//socket
	private var _sock:Socket;
	//缓冲数据,表示处理的消息比较长，通过网络一次发不完，需要接受多次才能合成完整的信息
	private var _bufferByteArray:ByteArray;
	
	//消息缓冲开关
	private var _isBufferring:Boolean = false;
	//从socket读取的消息头长度
	private var _messageLength:uint = 0;
	//正整数头长度，用于获取一个完整的信息长度
	private var _unsignedHeadLength:uint = SocketConnectionHead.LENGTH_SHORT;
	//是否允许读取消息头长度
	private var _canReadUnsignedHead:Boolean = true;
	
	public function SocketProxy(socket:Socket)
	{
		this._sock = socket;
		this.addListener(socket);
	}
	
	/**
	 * 是否已经连接
	 * @return	Boolean	连接成功
	 */
	public function get connected():Boolean
	{
		return this._sock.connected;
	}
	/**
	 * 立即发送数据
	 * @param	data	ByteArray	二进制数据
	 */
	public function send(data:ByteArray):void
	{
		this._sock.writeBytes(data, 0, data.length);
		this._sock.flush();
	}
	/**
	 * 销毁 实例,不包含Socket的close方法
	 */
	public function dispose():void
	{
		this.removeListener(this._sock);
		this._sock = null;
	}
	/**
	 * 关闭链接
	 */
	public function close():void
	{
		if(null != this._sock && this._sock.connected)
		{
			this.removeListener(this._sock);
			this._sock.close();
			this._sock = null;
		}
	}
	/**
	 * 链接实例
	 */	
	public function get socket():Socket
	{
		return this._sock;
	}
//Private---------------------------------------------------------------------------
	//添加侦听
	private function addListener(socket:Socket):void
	{
		socket.addEventListener(Event.CLOSE, onSocketClose);
		socket.addEventListener(Event.CONNECT, onSocketConnected);
		socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
		socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
	}
	//删除侦听
	private function removeListener(socket:Socket):void
	{
		socket.removeEventListener(Event.CLOSE, onSocketClose);
		socket.removeEventListener(Event.CONNECT, onSocketConnected);
		socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
		socket.removeEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
	}
	
	//侦听服务器关闭
	private function onSocketClose(evt:Event):void
	{
		var event:ConnectionEvent = new ConnectionEvent(ConnectionEvent.CONNECTION_CLOSE);
		this.dispatchEvent(event);
	}
	//侦听服务器连接成功
	private function onSocketConnected(evt:Event):void
	{
		var event:ConnectionEvent = new ConnectionEvent(ConnectionEvent.CONNECTION_CONNECTED);
		this.dispatchEvent(event);
	}
	//服务器安全错误
	private function onSocketSecurityError(evt:SecurityErrorEvent):void
	{
		var event:ConnectionEvent = new ConnectionEvent(ConnectionEvent.CONNECTION_SECURITYERROR);
		this.dispatchEvent(event);
	}
	private function onSocketIOError(evt:IOErrorEvent):void
	{
		var event:ConnectionEvent = new ConnectionEvent(ConnectionEvent.CONNECTION_IOERROR);
		this.dispatchEvent(event);
	}
	
	private function onSocketData(evt:ProgressEvent):void
	{
		processData();
	}
	
	//接收到信息
	private function processData():void
	{
		var event:ConnectionEvent;
		if(this._canReadUnsignedHead)
		{
			//读取长度一般为4的消息头，它代表整个消息的长度
			if(this._sock.bytesAvailable >= this._unsignedHeadLength)
			{
				switch(this._unsignedHeadLength)
				{
					case SocketConnectionHead.LENGTH_BYTE:
//						this._messageLength = this._sock.readUnsignedByte();
						//this._messageLength -= SocketConnectionHead.LENGTH_BYTE;
						break;
					case SocketConnectionHead.LENGTH_SHORT:
						this._messageLength = this._sock.readUnsignedShort();
//						this._messageLength -= SocketConnectionHead.LENGTH_SHORT;
						break;
					case SocketConnectionHead.LENGTH_INT:
//						this._messageLength = this._sock.readUnsignedInt();
						//this._messageLength -= SocketConnectionHead.LENGTH_INT;
						break;
					default :
						break;
				}
				this._canReadUnsignedHead = false;
				
			}
		}
		
		//已经读取消息长度, 下面处理 消息缓冲
		if(!this._canReadUnsignedHead)
		{
			//消息长度为0，消息为残废消息, 不为0则处理消息
			if(this._messageLength != 0)
			{
				//处理消息头长度小于可用字节长度
				if(this._messageLength <= this._sock.bytesAvailable)
				{
					//创建一个ByteArray实例，并读取socket缓冲中的 信息长度数据
					var dataByte:ByteArray = new ByteArray();
					//dataByte.endian = Endian.LITTLE_ENDIAN;
					dataByte.endian = Endian.LITTLE_ENDIAN;
					//补足消息长度位置
					
					this._sock.readBytes(dataByte, 0, this._messageLength);
					dataByte.position = 0;
					//有正确的完整数据，发送 数据到达事件
					event = new ConnectionEvent(ConnectionEvent.CONNECTION_DATA);
					event.data = dataByte;
					//开启读取消息头，以读取下一个消息
					this._canReadUnsignedHead = true;
				}
					//处理消息头长度大于可用字节长度
				else if(this._messageLength > this._sock.bytesAvailable)
				{
					//发送数据正在加载事件, 此data就是数据加载比例
					event = new ConnectionEvent(ConnectionEvent.CONNECTION_PROGRESS);
					event.data = this._sock.bytesAvailable / this._messageLength;
				}
			}
			else
			{
				//如果消息长度是0 则是 异常消息，抛出 异常事件
				event = new ConnectionEvent(ConnectionEvent.CONNECTION_INVAILD_DATA);
				//因为是异常消息，该消息不处理，直接读取下一个消息，打开读取开关
				this._canReadUnsignedHead = true;
			}
		}
		
		if(this._canReadUnsignedHead)
		{
			this.dispatchEvent(event);
			
			//如果套接字还有可用信息，继续解析
			if(this._sock.bytesAvailable >= this._unsignedHeadLength)
			{
				this.processData();
			}
		}
	}
}
}
