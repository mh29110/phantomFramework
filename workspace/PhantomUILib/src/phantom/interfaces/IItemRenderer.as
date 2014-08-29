package phantom.interfaces
{
	import phantom.core.handlers.Handler;

    public interface IItemRenderer 
    {
        /**
         * 当前渲染用数据
         */        
        function set data(value:Object):void
        function get data():Object;
        /**
         * 单击回调
         */        
		function set clickHandler(value:Handler):void;
		function set doubleClickHandler(value:Handler):void;
		
        function get selected():Boolean;
        function set selected(v:Boolean):void;
        
        function set toggle(v:Boolean):void;
    }
}