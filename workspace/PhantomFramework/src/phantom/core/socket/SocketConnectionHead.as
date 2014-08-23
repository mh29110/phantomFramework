////////////////////////////////////////////////////////////////////////////////////////////////////
//										Socket	连接 头类型和匹配长度
////////////////////////////////////////////////////////////////////////////////////////////////////
package phantom.core.socket
{
/**
 * Socket	连接 匹配长度
 * 单字节读取的Byte, 双字节的Short, 4字节的int
 */
public class SocketConnectionHead
{
	/**
	 *  byte头类型, 取1个字节
	 */
	public static const LENGTH_BYTE:uint = 1;
	/**
	 *  short头类型, 取2个字节
	 */
	public static const LENGTH_SHORT:uint = 2;
	/**
	 *  int头类型, 取4个字节
	 */
	public static const LENGTH_INT:uint = 4;
}
}