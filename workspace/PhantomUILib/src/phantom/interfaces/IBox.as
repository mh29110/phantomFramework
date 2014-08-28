package phantom.interfaces
{
    import flash.display.DisplayObject;

    public interface IBox extends ISkinAdapter
    {
        /**
         * 从 DisplayObjectContainer 实例的子列表中删除指定的 child DisplayObject 实例。 
         * @param            child
         * @return           删除的 child
         */        
        function removeChild(child:DisplayObject):DisplayObject
            
        /**
         * 从 DisplayObjectContainer 的子列表中指定的索引位置删除子 DisplayObject。
         * @param index     指定的索引
         * @return          删除的 child
         * 
         */        
        function removeChildAt(index:int):DisplayObject
            
        /**
         * 从 DisplayObjectContainer 实例的子级列表中删除所有 child DisplayObject 实例。
         * @param doDispose 是否要对实现IDisposable的对象进行释放操作
         * @see interfaces.IDisposable
         */        
        function removeChildren(doDispose:Boolean = true):void
            
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
        function addChild(child:DisplayObject):DisplayObject
            
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
        function addChildAt(child:DisplayObject, index:int):DisplayObject
            
        /**
         * 返回位于指定索引处的子显示对象实例
         * @param index         子对象的索引位置
         * @return              位于指定索引位置处的子显示对象
         * 
         */        
        function getChildAt(index:int):DisplayObject
        
        /**
         * 返回 DisplayObject 的 child 实例的索引位置
         * @param child         要标识的 DisplayObject 实例
         * @return              要标识的子显示对象的索引位置
         */        
        function getChildIndex(child:DisplayObject):int
            
        /**
         * 确定对象的子级是否支持鼠标或用户输入设备。如果对象支持鼠标或用户输入设备，用户可以通过使用鼠标或用户输入设备与之交互。默认值为 true。
         */            
        function set mouseChildren(value:Boolean):void
        function get mouseChildren():Boolean;
        
        /**
        * 子元件数量
        */ 
        function get numChildren():uint
    }
}