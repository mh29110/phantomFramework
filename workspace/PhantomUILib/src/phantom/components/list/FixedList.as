package phantom.components.list
{
	import flash.display.MovieClip;
	
	import phantom.components.Box;
	import phantom.components.list.data.DataProvider;
	import phantom.components.list.data.DefaultItemRenderer;
	import phantom.components.list.events.DataChangeEvent;
	import phantom.components.list.events.DataChangeType;
	import phantom.core.handlers.Handler;
	import phantom.interfaces.IItemRenderer;

	/**
	 * 采用复用ItemRender的方式来渲染内容.
	 * 必须包含组件:<br>
	 * 列表元件0~n(mc_item_[0~n])
	 * @author liphantomjia@gmail.com
	 */
	public class FixedList extends Box
	{
		private var _data:DataProvider;
		private var _itemRendererClassDefine:Class;
		private var _itemRenderList:Vector.<IItemRenderer>;
		private var _listItemCount:uint;
		private var _listStartIndex:uint;
		private var _needRefreshPage:Boolean;
		private var _itemDoubleClickEnabled:Boolean;
		private var _itemIndex:String;
		
		private var _currentSelectedItem:Array;
		private var _enabledSelect:Boolean;
		private var _enabledMultiSelect:Boolean;
		private var _maxSelectedCount:int;
		private var _clickHandler:Handler;
		
		/**
		 * 构造
		 * @param skin                      皮肤
		 * @param itemIndex                 (default: "mc_item") 列表元素索引前缀
		 * @param itemRenderClassDefine     (default: components.itemRenderer.DefaultItemRenderer) 列表内容渲染控制类
		 */        
		public function FixedList(skin:*, itemRendererClassDefine:Class = null, itemIndex:String = "mc_item")
		{
			if(itemRendererClassDefine == null)
			{
				itemRendererClassDefine = DefaultItemRenderer;
			}
			_maxSelectedCount = -1;
			_currentSelectedItem = null;
			_itemRendererClassDefine = itemRendererClassDefine;
			_itemIndex = itemIndex;
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void
		{
			super.initializeSkin(skin);
			
			_itemRenderList = new Vector.<IItemRenderer>();
			var itemRender:IItemRenderer;
			var mc:MovieClip;
			var index:int = 0;
			while(true)
			{
				mc = getMcPath(_itemIndex + "_" + index++);
				if(mc)
				{
					itemRender = new _itemRendererClassDefine(mc) as IItemRenderer;
					itemRender.clickHandler = new Handler(onItemClick);
					itemRender.doubleClickHandler = new Handler(onItemDoubleClick);
					itemRender.data = null;
					_itemRenderList.push(itemRender);
				}
				else
				{
					break;
				}
			}
			_listItemCount = _itemRenderList.length;
		}
		

//-------------------render -------------------------------------
		override protected function render():void
		{
			super.render();
			checkNeedRefreshPage();
		}
		
		protected function checkNeedRefreshPage():void
		{
			if(!_needRefreshPage)
			{
				return;
			}
			
			_needRefreshPage = false;
			
			var itemsCount:int = _data.dataLen;
			var len:int = _listItemCount;
			var index:int;
			var itemData:Object;
			for(var i:int = 0; i<len; i++)
			{
				index = i + _listStartIndex;
				if(index<itemsCount)
				{
					itemData = _data.getItemAt(index);
				}
				else
				{
					itemData = null;
				}
				_itemRenderList[i].data = itemData;
			}
			
			refreshSelection();
		}
		
		protected function refreshSelection():void
		{
			if(_enabledSelect==false || _currentSelectedItem==null)
			{
				return;
			}
			
			var selectIndex : int;
			var itemRender : IItemRenderer;
			for (var i:int = _itemRenderList.length-1; i>=0; i--) 
			{
				itemRender = _itemRenderList[i];
				selectIndex = _currentSelectedItem.indexOf(itemRender.data);
				itemRender.selected = Boolean(selectIndex>=0);
			}
		}
//------------------------------handler -onClick-----------------
		/**
		 * 列表元素被单击的处理
		 */        
		protected function onItemClick(value:IItemRenderer):void
		{
			var renderData:Object = value.data;
			
			if(!renderData)
			{
				return;
			}
			if(_enabledSelect)
			{
				if(_enabledMultiSelect)
				{
					if(!_currentSelectedItem)
					{
						_currentSelectedItem = [];
					}
					
					var index:int = _currentSelectedItem.indexOf(renderData);
					if(index>=0||_maxSelectedCount<0||_currentSelectedItem.length<_maxSelectedCount)
					{
						if(index<0)
						{
							_currentSelectedItem.push(renderData);
							resetItemSelection(renderData, true);
						}
						else
						{
							resetItemSelection(_currentSelectedItem[index], false);
							_currentSelectedItem.splice(index,1);
							if(_currentSelectedItem.length==0)
							{
								deselect();
							}
						}
					}
				}
				else
				{
					if(_currentSelectedItem && renderData != _currentSelectedItem[0])
					{
						resetItemSelection(_currentSelectedItem[0], false);
					}
					_currentSelectedItem=[renderData];
					resetItemSelection(renderData, true);
				}
			}
			_clickHandler.executeWith([renderData,value]);
		}
		
		/**
		 * 列表元素被双击的处理. 必须开启双击才能有用.
		 */        
		protected function onItemDoubleClick(value:IItemRenderer):void
		{
			//_doubleClickHandler.executeWith([renderData,value]);
		}
		
		/**
		 * 检查数据是否在当前页，并改变状态
		 * @param selectItem 要改状态的数据，与_currentSelectedItem关联
		 * @param selected 要变成的状态
		 * 
		 */
		protected function resetItemSelection(selectItem:Object, selected:Boolean):void
		{
			var itemRender : IItemRenderer
			for (var i:int = _itemRenderList.length-1; i>=0; i--) 
			{
				itemRender = _itemRenderList[i];
				if(itemRender.data == selectItem)
				{
					itemRender.selected = selected;
					break;
				}
			}
		}
		
		public function deselect():void
		{
			_currentSelectedItem = null;
			if(_enabledSelect)
			{
				for (var i:int = _itemRenderList.length-1; i>=0; i--) 
				{
					_itemRenderList[i].selected = false;
				}
			}
		}
		
		protected function refreshPage():void
		{
			_needRefreshPage = true;
			invalidate();
		}
//--------------------------------data--------------------------------		
		/**
		 * 数据
		 */        
		public function get data():DataProvider
		{
			return _data;
		}
		public function set data(value:DataProvider):void
		{
			if(value != _data)
			{
				if(_data)
				{
					_data.removeEventListener(DataChangeEvent.DATA_CHANGE, onDataChangeEventHandle);
					_data.removeEventListener(DataChangeEvent.PRE_DATA_CHANGE, onDataChangeEventHandle);
				}
				
				deselect();
				
				value.addEventListener(DataChangeEvent.DATA_CHANGE, onDataChangeEventHandle);
				value.addEventListener(DataChangeEvent.PRE_DATA_CHANGE, onDataChangeEventHandle);
				_data = value;
				refreshPage();
			}
		}
		
		protected function onDataChangeEventHandle(e:DataChangeEvent):void
		{
			switch(e.type)
			{
				case DataChangeEvent.DATA_CHANGE:
				{
					refreshPage();
					break;
				}
				case DataChangeEvent.PRE_DATA_CHANGE:
				{
					switch(e.changeType)
					{
						case DataChangeType.REPLACE:
						case DataChangeType.REMOVE:
						{
							if(_currentSelectedItem)
							{
								var index:int = _currentSelectedItem.indexOf(e.items[0]);
								if(index>=0)
								{
									resetItemSelection(_currentSelectedItem[index], false);
									_currentSelectedItem.splice(index,1);
								}
								if(_currentSelectedItem.length == 0)
								{
									deselect();
								}
							}
							break;
						}
						case DataChangeType.REMOVE_ALL:
						{
							deselect();
							break;
						}
					}
					break;
				}
			}
			
		}
		
		public function set enabledMultiSelect(v:Boolean):void
		{
			_enabledMultiSelect = v;
		}
		public function get enabledMultiSelect():Boolean
		{
			return _enabledMultiSelect;
		}
		
		public function set enabledSelect(v:Boolean):void
		{
			_enabledSelect = v;
			for(var i:int = 0; i<_itemRenderList.length; i++)
			{
				_itemRenderList[i].toggled = v;
			}
		}
		
		public function get enabledSelect():Boolean
		{
			return _enabledSelect;
		}
		public function set currentSelectedItem(v:Object):void
		{
			if(enabledSelect==false)
			{
				return;
			}
			
			var len:int;
			var i:int;
			var list:Array;
			
			if(v)
			{
				if(v is Array)
				{
					_currentSelectedItem = v as Array;
				}
				else
				{
					_currentSelectedItem = [v];
				}
				refreshSelection();
			}
		}
		public function get currentSelectedItem():Object
		{
			if(_currentSelectedItem)
			{
				if(_enabledMultiSelect)
				{
					return _currentSelectedItem;
				}
				else
				{
					return _currentSelectedItem[0];
				}
			}
			return null;
		}
		
		/**
		 * 列表开始索引
		 */        
		public function get listStartIndex():uint
		{
			return _listStartIndex;
		}
		public function set listStartIndex(value:uint):void
		{
			if(_listStartIndex == value)
			{
				return;
			}
			
			_listStartIndex = value;
			refreshPage();
		}
		
		/**
		 * 是否启用双击. 只有在启用的情况下. 设置的onDoubleClickHandle回调才有意义.
		 */        
		public function get itemDoubleClickEnabled():Boolean
		{
			return _itemDoubleClickEnabled;
		}
		public function set itemDoubleClickEnabled(value:Boolean):void
		{
			_itemDoubleClickEnabled = value;
			var len:int = _itemRenderList.length;
			for(var i:int = 0; i<len; i++)
			{
				_itemRenderList[i].doubleClickEnabled = value;
			}
		}
		
		/**点击处理器(无默认参数)*/
		public function get clickHandler():Handler 
		{
			return _clickHandler;
		}
		
		public function set clickHandler(value:Handler):void 
		{
			_clickHandler = value;
		}
		
		/**
		 * 内容渲染列表
		 */        
		public function get itemRenderList():Vector.<IItemRenderer>
		{
			return _itemRenderList;
		}
		
		/**
		 * 内容渲染列表个数
		 */        
		public function get listItemCount():uint
		{
			return _listItemCount;
		}
		
		public function get maxScrollV():uint
		{
			var dataLen:int;
			if(data)
			{
				dataLen = data.dataLen;
			}
			return Math.max(0, dataLen - listItemCount);
		}
		
		override protected function destruct():void
		{
			super.destruct();
			
			if(_data)
			{
				_data.removeEventListener(DataChangeEvent.DATA_CHANGE, onDataChangeEventHandle);
				_data.removeEventListener(DataChangeEvent.PRE_DATA_CHANGE, onDataChangeEventHandle);
			}
			
			if(_itemRenderList)
			{
				_itemRenderList.length = 0;
			}
			
			_itemRendererClassDefine = null;
			_data = null;
		}
		
		public function set maxSelectedCount(value:int):void
		{
			_maxSelectedCount = value;            
		}
		
		public function get maxSelectedCount():int
		{
			return _maxSelectedCount;
		}
	}
}