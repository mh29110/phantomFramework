package phantom.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import phantom.core.handlers.Handler;
	import phantom.core.utils.StringUtils;
	
	public class WindowBase extends Box {
		public static const CLOSE:String = "close";
		public static const CANCEL:String = "cancel";
		public static const SURE:String = "sure";
		public static const NO:String = "no";
		public static const OK:String = "ok";
		public static const YES:String = "yes";
		
		protected var _dragArea:Rectangle;
		protected var _popupCenter:Boolean = true;
		protected var _closeHandler:Handler;
		
		public function WindowBase(skin:*) {
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void
		{
			super.initializeSkin(skin);
			var dragTarget:DisplayObject = getMcPath("drag");
			if (dragTarget) {
				dragArea = dragTarget.x + "," + dragTarget.y + "," + dragTarget.width + "," + dragTarget.height;
//				removeChild(dragTarget);
			}
			view.addEventListener(MouseEvent.CLICK, onClick);
			
			//增加关闭按钮是否必要?
		}
		
		/**默认按钮处理*/
		protected function onClick(e:MouseEvent):void {
			var btn:Button = e.target as Button;
			if (btn) {
				switch (btn.name) {
					case CLOSE: 
					case CANCEL: 
					case SURE: 
					case NO: 
					case OK: 
					case YES: 
						close(btn.name);
						break;
				}
			}
		}
		
		/**关闭对话框*/
		public function close(type:String = null):void {
			if (_closeHandler != null) {
				_closeHandler.executeWith([type]);
			}
		}
		
		/**拖动区域(格式:x:Number=0, y:Number=0, width:Number=0, height:Number=0)*/
		public function get dragArea():String {
			return StringUtils.rectToString(_dragArea);
		}
		
		public function set dragArea(value:String):void {
			if (Boolean(value)) {
				var a:Array = StringUtils.fillArray([0, 0, 0, 0], value);
				_dragArea = new Rectangle(a[0], a[1], a[2], a[3]);
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			} else {
				_dragArea = null;
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (_dragArea.contains(mouseX, mouseY)) {
				AppCenter.instance.drag.doDrag(this.view as Sprite);
			}
		}
		
		/**是否弹出*/
		public function get isPopup():Boolean {
			return parent != null;
		}
		
		/**关闭回调(返回按钮名称name:String)*/
		public function get closeHandler():Handler {
			return _closeHandler;
		}
		
		public function set closeHandler(value:Handler):void {
			_closeHandler = value;
		}
	}
}