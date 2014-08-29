// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package phantom.components.list.events
{

	/**
	 * DataChangeType 类定义 DataChangeEvent.changeType 事件的常量。DataChangeEvent 类使用这些常量，来标识应用到基于列表的组件中数据的更改类型。
	 *
     * @see DataChangeEvent#changeType
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 * @playerversion AIR 1.0	 * @productversion Flash CS3
	 */
	public class DataChangeType 
    {

		/**
         * 更改了组件数据。该值不影响它所描述的组件数据。
         *
         * @eventType change
         * 
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 * @playerversion AIR 1.0		 * @productversion Flash CS3
		 */
		public static const CHANGE:String = "change";
		
		/**
         * 更改了项目中包含的数据。
         *
         * @eventType invalidate
         * 
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 * @playerversion AIR 1.0		 * @productversion Flash CS3
		 */
		public static const INVALIDATE:String = "invalidate";
		
		/**
         * 数据集无效。
         *
         * @eventType invalidateAll
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 * @playerversion AIR 1.0		 * @productversion Flash CS3
		 */
		public static const INVALIDATE_ALL:String = "invalidateAll";

		/**
         * 将项目添加到了数据提供程序。
		 *
         * @eventType add
         * 
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 * @playerversion AIR 1.0		 * @productversion Flash CS3
		 */
		public static const ADD:String = "add";

		/**
         * 从数据提供程序中删除了项目。
		 *
         * @eventType remove
         * 
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 * @playerversion AIR 1.0		 * @productversion Flash CS3
		 */
		public static const REMOVE:String = "remove";
		
		/**
         * 从数据提供程序中删除了所有项目。
		 *
         * @eventType removeAll
         * 
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 * @playerversion AIR 1.0		 * @productversion Flash CS3
		 */
		public static const REMOVE_ALL:String = "removeAll";

		/**
         * 新项目替换了数据提供程序中的项目。
		 *
         * @eventType replace
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 * @playerversion AIR 1.0		 * @productversion Flash CS3
		 */
		public static const REPLACE:String = "replace";

		/**
         * 对数据提供程序进行了排序。该常量用于指示数据顺序的更改，而不是数据本身的更改。
		 *
         * @eventType sort
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 * @playerversion AIR 1.0		 * @productversion Flash CS3
		 */
		public static const SORT:String = "sort";
	}
}