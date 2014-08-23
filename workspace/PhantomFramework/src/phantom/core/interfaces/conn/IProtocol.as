package phantom.core.interfaces.conn
{
	import flash.utils.ByteArray;

	public interface IProtocol
	{
		function init(data:ByteArray):void ;
		function toBytes():ByteArray;
		function getID():uint;
	}
}