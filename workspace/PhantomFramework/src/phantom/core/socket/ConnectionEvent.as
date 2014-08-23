////////////////////////////////////////////////////////////////////////////////////////////////////
//											连接 事件
////////////////////////////////////////////////////////////////////////////////////////////////////
package phantom.core.socket
{
import flash.events.Event;

/**
 * 外部连接事件,包括Socket,http
 */
public class ConnectionEvent extends Event
{
	/**
	 * 连接断开
	 */
	public static const CONNECTION_CLOSE:String = "connection_close";
	/**
	 * 连接成功
	 */
	public static const CONNECTION_CONNECTED:String = "connection_connected";
	/**
	 * 获得完整数据包
	 */
	public static const CONNECTION_DATA:String = "connection_data";
	/**
	 * 异常数据
	 */
	public static const CONNECTION_INVAILD_DATA:String = "connection_invaild_data";
	/**
	 * 连接安全错误
	 */
	public static const CONNECTION_SECURITYERROR:String = "connection_securityerror";
	/**
	 * 连接错误
	 */
	public static const CONNECTION_IOERROR:String = "connection_ioerror";
	/**
	 * 数据传输
	 */
	public static const CONNECTION_PROGRESS:String = "connection_progress";
	/**
	 * 完整数据包
	 * @param	data	*	完整数据包
	 */
	public var data:*;
	public function ConnectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
}
}