// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package phantom.components.list.events
{
    import flash.events.Event;
    
    /**
     * DataChangeEvent 类定义事件，该事件在与组件关联的数据更改时调度。List、DataGrid、TileList 和 ComboBox 组件使用该事件。
     *
     * <p>该类提供下列事件：</p>
     * <ul>
     *     <li><code>DataChangeEvent.DATA_CHANGE</code>: 在组件数据更改时调度。</li>
     * </ul>
     *
     *
     * @see DataChangeType
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @playerversion AIR 1.0     * @productversion Flash CS3
     */
    public class DataChangeEvent extends Event 
    {
        /**
         * 定义 dataChange 事件对象的 type 属性值。
         *
         * <p>此事件具有以下属性:</p>
         *  <table class="innertable" width="100%">
         *     <tr><th>Property</th><th>Value</th></tr>
         * 	   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
         *     <tr><td><code>cancelable</code></td><td><code>false</code>; 没有要取消的默认行为。</td></tr>
         *     <tr><td><code>changeType</code></td><td>标识所做更改的类型。</td></tr>
         *	   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理 Event 对象的对象。</td></tr>
         *     <tr><td><code>endIndex</code></td><td>标识最后一个更改的项目的索引。</td></tr>
         *     <tr><td><code>items</code></td><td>列出更改的项目的数组。</td></tr>
         *     <tr><td><code>startIndex</code></td><td>标识第一个更改的项目的索引。</td></tr>
         *     <tr><td><code>target</code></td><td>调度了事件的对象。target 不一定是侦听该事件的对象。使用 currentTarget 属性可以访问侦听该事件的对象。</td></tr>
         *  </table>
         *
         * @eventType dataChange
         *
         * @see #PRE_DATA_CHANGE
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public static const DATA_CHANGE:String = "dataChange";
        
        /**
         * 定义 preDataChange 事件对象的 type 属性值。该事件对象在更改组件数据之前调度。
         *
         * <p>此事件具有以下属性:</p>
         *  <table class="innertable" width="100%">
         *     <tr><th>Property</th><th>Value</th></tr>
         * 	   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
         *     <tr><td><code>cancelable</code></td><td><code>false</code>; 没有要取消的默认行为。</td></tr>
         *     <tr><td><code>changeType</code></td><td>标识所做更改的类型。</td></tr>
         *	   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理 Event 对象的对象。</td></tr>
         *     <tr><td><code>endIndex</code></td><td>标识最后一个更改的项目的索引。</td></tr>
         *     <tr><td><code>items</code></td><td>列出更改的项目的数组。</td></tr>
         *     <tr><td><code>startIndex</code></td><td>标识第一个更改的项目的索引。</td></tr>
         *     <tr><td><code>target</code></td><td>调度了事件的对象。target 不一定是侦听该事件的对象。使用 currentTarget 属性可以访问侦听该事件的对象。</td></tr>
         *  </table>
         * 
         * @eventType preDataChange
         *
         * @see #DATA_CHANGE
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public static const PRE_DATA_CHANGE:String = "preDataChange";
        
        
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        protected var _startIndex:uint;
        
        
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        protected var _endIndex:uint;
        
        
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        protected var _changeType:String;
        
        
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        protected var _items:Array;
        
        /**
         * 使用指定的参数创建新的 DataChangeEvent 对象。
         *
         * @param eventType change 事件的类型。
         * @param changeType 所做更改的类型。DataChangeType 类定义此参数的可能值。
         * @param items 更改的项目的列表。
         * @param startIndex  (default = -1) 所更改的第一个项目的索引。
         * @param endIndex (default = -1) 所更改的最后一个项目的索引。
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function DataChangeEvent(eventType:String, changeType:String, items:Array,startIndex:int=-1, endIndex:int=-1):void 
        {
            super(eventType);
            _changeType = changeType;
            _startIndex = startIndex;
            _items = items;
            _endIndex = (endIndex == -1) ? _startIndex : endIndex;
        }
        
        /**
         * 获取触发事件的更改类型。DataChangeType 类定义此属性的可能值。
         *
         * @see DataChangeType
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function get changeType():String 
        {
            return _changeType;
        }
        
        /**
         * 获取包含更改的项目的数组。
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function get items():Array 
        {
            return _items;
        }
        
        /**
         * 获取更改的项目数组中第一个更改的项目的索引。
         *
         * @see #endIndex
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function get startIndex():uint 
        {
            return _startIndex;
        }
        
        /**
         * 获取更改的项目数组中最后一个更改的项目的索引。
         *
         * @see #startIndex
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function get endIndex():uint 
        {
            return _endIndex;
        }
        
        
        /**
         * 返回一个字符串，其中包含 DataChangeEvent 对象的所有属性。字符串的格式如下：
         * 
         * <p>[<code>DataChangeEvent type=<em>value</em> changeType=<em>value</em> 
         * startIndex=<em>value</em> endIndex=<em>value</em>
         * bubbles=<em>value</em> cancelable=<em>value</em></code>]</p>
         *
         * @return 一个字符串，其中包含 DataChangeEvent 对象的所有属性。
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        override public function toString():String 
        {
            return formatToString("DataChangeEvent", "type", "changeType", "startIndex", "endIndex", "bubbles", "cancelable");
        }
        
        
        
        /**
         * 创建 DataEvent 对象的副本，并设置每个参数的值以匹配原始参数值。
         *
         * @return 其属性值与原始属性值匹配的新 DataChangeEvent 对象。

         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        override public function clone():Event 
        {
            return new DataChangeEvent(type, _changeType, _items, _startIndex, _endIndex);
        }
    }
}