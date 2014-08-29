package phantom.components
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    
    import phantom.core.interfaces.IDispose;
    import phantom.interfaces.IBox;
    
    public class Box extends ComponentAdapter implements IBox
    {
        private var _adapterList:Vector.<ComponentAdapter>;
        private var _container:DisplayObjectContainer;
        
        public function Box(skin:*)
        {
            _adapterList = new Vector.<ComponentAdapter>();
            super(skin);
        }
        
        /**
         * 从 DisplayObjectContainer 实例的子列表中删除指定的 child DisplayObject 实例。 
         * @param            child
         * @return           删除的 child
         */        
        public function removeChild(child:DisplayObject):DisplayObject
        {
            return container.removeChild(child);;
        }
        
        /**
         * 从 DisplayObjectContainer 的子列表中指定的索引位置删除子 DisplayObject。
         * @param index     指定的索引
         * @return          删除的 child
         * 
         */        
        public function removeChildAt(index:int):DisplayObject
        {
            var child:DisplayObject = container.removeChildAt(index);
            return child;
        }
        
        /**
         * 从 DisplayObjectContainer 实例的子级列表中删除所有 child DisplayObject 实例。
         * @param doDispose 是否要对实现IDisposable的对象进行释放操作
         * @see interfaces.IDisposable
         */        
        public function removeChildren(doDispose:Boolean = true):void
        {
            var childCouldDispose:IDispose;
            while(numChildren)
            {
                childCouldDispose = removeChildAt(0) as IDispose;
                if(childCouldDispose && doDispose)
                {
                    childCouldDispose.dispose();
                }
            }
        }
        
        /**
         * 将一个 DisplayObject 子实例添加到该 DisplayObjectContainer 实例中。<br>
         * 子项将被添加到该 DisplayObjectContainer 实例中其他所有子项的前（上）面。<br>
         * 如果添加一个已将其它显示对象容器作为父项的子对象，<br>
         * 则会从其它显示对象容器的子列表中删除该对象。<br>
         * <font color="#ff0000">（要将某子项添加到特定索引位置，请使用 addChildAt() 方法。）</font>
         * 
         * @param child         子实例
         * @return              添加的子实例
         */        
        public function addChild(child:DisplayObject):DisplayObject
        {
            return container.addChild(child);
        }
        
        /**
         * 返回位于指定索引处的子显示对象实例
         * @param index         子对象的索引位置
         * @return              位于指定索引位置处的子显示对象
         * 
         */        
        public function getChildAt(index:int):DisplayObject
        {
            return container.getChildAt(index);
        }
        
        /**
         * 返回 DisplayObject 的 child 实例的索引位置
         * @param child         要标识的 DisplayObject 实例
         * @return              要标识的子显示对象的索引位置
         */        
        public function getChildIndex(child:DisplayObject):int
        {
            return container.getChildIndex(child);
        }
        
        /**
         * 将一个 DisplayObject 子实例添加到该 DisplayObjectContainer 实例中。<br>
         * 该子项将被添加到指定的索引位置。<br>
         * 索引为 0 表示该 DisplayObjectContainer 对象的显示列表的后（底）部。<br>
         * 如果添加一个已将其它显示对象容器作为父项的子对象，<br>
         * 则会从其它显示对象容器的子列表中删除该对象。<br>
         * 
         * @param child         子实例
         * @param index         指定的索引位置
         * @return              添加的子实例
         */        
        public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
            return container.addChildAt(child, index);
        }
        
        override protected function initializeSkin(skin:*):void
        {
            _container = skin;
        }
        
        /**
         * 增加ui连接器
         * @param adapter ui连接器
		 * 为了在destruct时dispose.
         */
        protected function addAdapter(adapter:ComponentAdapter):void
        {
            if(adapter && _adapterList.indexOf(adapter)<0)
            {
                _adapterList.push(adapter);
            }
        }
        
        /**
         * 移除ui连接器
         * @param adapter ui连接器
         */
        protected function removeAdapter(adapter:ComponentAdapter):Boolean
        {
            if(adapter)
            {
                var index:int = _adapterList.indexOf(adapter);
                if(index<0)
                {
                    return false;
                }
                
                _adapterList.splice(index,1);
                
                return true;
            }
            return false;
        }
        
        
        override public function set mouseChildren(value:Boolean):void
        {
            container.mouseChildren = value;
        }
        public function get mouseChildren():Boolean
        {
            return container.mouseChildren;
        }
        
        /**
         * 子元件数量
         */        
        public function get numChildren():uint
        {
            return container.numChildren;
        }
        
        override public function get view():DisplayObject
        {
            return _container;
        }
        
        protected function get container():DisplayObjectContainer
        {
            return _container;
        }
		
		override protected function destruct():void
		{
			super.destruct();
			
			var disposeNode:IDispose;
			if(_adapterList)
			{
				while(_adapterList.length)
				{
					disposeNode = _adapterList.pop() as IDispose;
					if(disposeNode)
					{
						disposeNode.dispose();
					}
				}
			}
		}
    }
}