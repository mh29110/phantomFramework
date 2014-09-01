package phantom.components.list
{
	import flash.display.InteractiveObject;
	
	import phantom.components.ScrollBar;
	import phantom.components.list.data.DataProvider;
	import phantom.core.handlers.Handler;

	/**
	 * UI设计在flash中固定的list,自带滚动条,但是无法平滑滑动内容.
	 * List 与 ScrollBar 的组合
	 * 采用复用ItemRender的方式来渲染内容.
	 * 另参见 @SlideList
	 * @author liphantomjia@gmail.com
	 */
	public class List extends FixedList
	{
		private var _scrollBar:ScrollBar;
		
		private var PREFIX_LIST:String = "mc_list.";
		private var PREFIX_SCROLL:String = "mc_scroll";
		private var _itemRendererClassDefine:Class;
		private var _cellSize:int ;
		/**
		 * 构造
		 * @param skin                      皮肤
		 * @param itemRenderClassDefine     (default: components.itemRenderer.DefaultItemRenderer) 列表内容渲染控制类
		 * @param itemIndex                 (default: "mc_item") 列表元素索引前缀. 注意在flash中层次结构为   listName.mc_list.mc_item 0-n
		 */        
		public function List(skin:*, itemRendererClassDefine:Class = null, cellSize:int = 1,itemIndex:String = "mc_item")
		{
			_itemRendererClassDefine = itemRendererClassDefine;
			_cellSize = cellSize;
			super(skin,_itemRendererClassDefine,PREFIX_LIST + itemIndex);
		}
		
		override protected function initializeSkin(skin:*):void
		{
			super.initializeSkin(skin);
			
			_scrollBar = new ScrollBar(getMcPath(PREFIX_SCROLL));
			addAdapter(_scrollBar);
			_scrollBar.changeHandler = new Handler(onScrollChangeHandler);
			_scrollBar.target = view as InteractiveObject;//使得List支持鼠标滑轮滚动
		}
//------------------scroll related----------------------------------		
		private function onScrollChangeHandler(value:Number):void
		{
			percent = value/_scrollBar.max;
		}
		
		public function set percent(value:Number):void
		{
			listStartIndex = Math.max(0, Math.min(Math.round(maxScrollV*value), maxScrollV));
		}
//----------------update scroll state--------------
		override public function set data(value:DataProvider):void
		{
			super.data = value;
			if (_scrollBar) {
				//自动隐藏滚动条
				var dataLen:int = data.dataLen;
				var itemLen:int = listItemCount;
				var numX:int = _cellSize;
				var _totalPage:int = Math.ceil(dataLen / itemLen);
				_scrollBar.visible = _totalPage > 1;
				if (_scrollBar.visible) {
					_scrollBar.scrollSize = _cellSize;
//					_scrollBar.thumbPercent = numY / lineCount;
					_scrollBar.setScroll(0, dataLen-itemLen,0);
				} else {
					_scrollBar.setScroll(0, 0, 0);
				}
			}

		}
	}
}