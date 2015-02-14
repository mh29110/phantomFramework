package phantom.components.list.data
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import phantom.components.Button;
	import phantom.core.handlers.Handler;
	import phantom.interfaces.IItemRenderer;
	
	public class DefaultItemRenderer extends Button implements IItemRenderer
	{
		private var _data:Object;
		private var _needRefreshData:Boolean;
		private var _onDoubleClick:Function;
		
		public function DefaultItemRenderer(skin:MovieClip)
		{
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void
		{
			super.initializeSkin(skin);
			data = null;
		}
		
		override protected function render():void
		{
			super.render();
			if(_needRefreshData)
			{
				_needRefreshData = false;
				refreshData();
			}
			
		}
		
		protected function refreshData():void
		{
			if(data)
			{
				visible = true;
			}
			else
			{
				visible = false;
			}
		}
		
		override protected function onMouse(e:MouseEvent):void 
		{
			if ((_toggle == false && _selected) || _disabled) {
				return;
			}
			if (e.type == MouseEvent.CLICK) {
				if (_toggle) {
					selected = !_selected;
				}
				if (_clickHandler) {
					_clickHandler.executeWith([this]);
				}
				return;
			}
			if (_selected == false) {
				state = stateMap[e.type];
			}
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			_needRefreshData = true;
			invalidate();
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set doubleClickHandler(value:Handler):void
		{
			//todo
		}
	}
}