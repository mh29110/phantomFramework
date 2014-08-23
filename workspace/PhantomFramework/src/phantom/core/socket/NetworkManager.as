package phantom.core.socket
{


import flash.events.Event;
import flash.net.Socket;
import flash.system.Security;
import flash.utils.ByteArray;

import phantom.core.interfaces.IManager;
import phantom.core.interfaces.conn.IProtocol;
import phantom.core.socket.conn.SocketReceiveListRegister;
import phantom.core.socket.conn.MessageDataType;
import phantom.core.socket.conn.MessageProcessor;

/**
 * 链接管理器
 */
public class NetworkManager implements IManager 
{
	//主游戏链接
	private var _gameConn:SocketProxy;
	
	private var _messageProcessor:MessageProcessor;
	public function NetworkManager()
	{
		//启动
		//SocketReceiveListRegister.init();
		
		_messageProcessor = new MessageProcessor();
		_messageProcessor.type = MessageDataType.SOCKET;
	}
//Public---------------------------------------------------------------------------
	/**
	 * 创建一个联接
	 * @param	connectionType	uint	联接类型
	 * @param	host			String	
	 * @param	port			int		
	 * @param	securityPort	int		安全策略服务器端口(ip地址和服务器是一样的)
	 * @see org.game.tk.manager.conn.net.ConnectionType
	 */
	//public function createSocket(connectionType:uint, host:String, port:int):void
	public function createSocket(connectionType:uint, host:String, port:int, securityPort:int = 843):void
	{
		var socket:Socket = new Socket();
		this.setSocket(socket, connectionType);
		Security.loadPolicyFile("xmlsocket://" + host + ":" + securityPort);
		socket.connect(host, port);
	}
	/**
	 * 
	 * @param	socket			Socket	外部实例化的链接
	 * @param	connectionType	uint	链接类型
	 * @see org.game.tk.manager.conn.net.ConnectionType
	 */	
	public function setSocket(socket:Socket, connectionType:uint):void
	{
		this._gameConn = new SocketProxy(socket);
		this.addSocketProxyLS(this._gameConn);
	}
	
	/**发送消息到服务器*/
	public function send(message:IProtocol):void
	{
		if(null != this._messageProcessor)
		{
			this._messageProcessor.message = message;
			//转换,前面打上头
			var data:ByteArray = this._messageProcessor.data;
			this._gameConn.send(data);
			
			switch(this._messageProcessor.type)
			{
				case MessageDataType.SOCKET:
					trace("->已经发送消息:" + message + " 长度: " + ByteArray(data).length);
					break;
			}
		}
		else
		{
			throw new Error("请先设置ConnectionManager的messageProcessor");
		}
	}
	
	
//Private---------------------------------------------------------------------------
	private function addSocketProxyLS(proxy:SocketProxy):void
	{
		proxy.addEventListener(ConnectionEvent.CONNECTION_CLOSE, onSocketClose);
		proxy.addEventListener(ConnectionEvent.CONNECTION_CONNECTED, onSocketConnected);
		proxy.addEventListener(ConnectionEvent.CONNECTION_DATA, onSocketData);
		proxy.addEventListener(ConnectionEvent.CONNECTION_IOERROR, onSocketIOError);
		proxy.addEventListener(ConnectionEvent.CONNECTION_SECURITYERROR, onSocketSecurityError);
	}
	private function removeSocketProxyLS(proxy:SocketProxy):void
	{
		proxy.removeEventListener(ConnectionEvent.CONNECTION_CLOSE, onSocketClose);
		proxy.removeEventListener(ConnectionEvent.CONNECTION_CONNECTED, onSocketConnected);
		proxy.removeEventListener(ConnectionEvent.CONNECTION_DATA, onSocketData);
		proxy.removeEventListener(ConnectionEvent.CONNECTION_IOERROR, onSocketIOError);
		proxy.removeEventListener(ConnectionEvent.CONNECTION_SECURITYERROR, onSocketSecurityError);
	}
	private function processData(data:ByteArray):void
	{
		var id:uint = data.readUnsignedShort();
		var messageClass:Class = SocketReceiveListRegister.getDataClassByID(id);
		//类型待确定
		if(null == messageClass)
		{
			trace("!-已接受到错误消息号, 可能是由于服务器与客户端消息号不一致或没有注册该协议引起的错误。 消息号:" + id);
		}
		else
		{
			var message:IProtocol = new messageClass;
			trace("<-已接受到消息:" + message + " 消息号:" + id);
			var commandType:String = SocketReceiveListRegister.getCommandTypeByID(id);
			message.init(data);
//			this.notify(commandType, message);
		}
	}
//Event-------------------------------------------------------------------------
	//侦听服务器关闭
	private function onSocketClose(evt:Event):void
	{
		this.removeSocketProxyLS(this._gameConn);
	}
	//侦听服务器连接成功
	private function onSocketConnected(evt:Event):void
	{
		trace("NetworkManager.onSocketConnected(evt)");
		
//		this.notify(CMDTypeConn.ConnectionConnectedCMD);
	}
	//服务器安全错误
	private function onSocketSecurityError(evt:ConnectionEvent):void
	{
		this.removeSocketProxyLS(this._gameConn);
//		this.notify(CMDTypeConn.ConnectionCloseCMD);
	}
	private function onSocketIOError(evt:ConnectionEvent):void
	{
		this.removeSocketProxyLS(this._gameConn);
//		this.notify(CMDTypeConn.ConnectionCloseCMD);
	}
	private function onSocketData(evt:ConnectionEvent):void
	{
		this.processData(evt.data);
	}
}
}

