package phantom.interfaces
{
	public interface IScreenAdapater extends IContainer
	{
		/**
		 * 面板中间件
		 */        
		function get screenMediator():IScreenAdapterMediator;
		
		/**
		 * 设置控制器的中间件
		 * @param mediator      中间件
		 */        
		function setMediator(mediator:IScreenAdapterMediator):void;
	}
}