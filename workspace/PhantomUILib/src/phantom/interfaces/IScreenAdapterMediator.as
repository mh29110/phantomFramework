package phantom.interfaces
{
	public interface IScreenAdapterMediator
	{
		function initMediator(...arg):void;
		
		function activeScreen():void;
		function deactiveScreen():void;
		function closeScreen():void
		function get isMajorScreen():Boolean;
		function get onInitScreenAssets():Boolean;
		function get initialized():Boolean;
	}
}