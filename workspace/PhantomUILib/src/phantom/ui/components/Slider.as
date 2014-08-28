package phantom.ui.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import phantom.core.handlers.Handler;
	import phantom.ui.components.Button;
	import phantom.ui.components.Label;
	
	/**滑动条变化后触发*/
	[Event(name="change",type="flash.events.Event")]
	
	/**滑动条*/
	public class Slider extends ComponentAdapter {
		/**水平移动*/
		public static const HORIZONTAL:String = "horizontal";
		/**垂直移动*/
		public static const VERTICAL:String = "vertical";
		protected var _allowBackClick:Boolean;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _tick:Number = 1;
		protected var _value:Number = 0;
		protected var _direction:String = VERTICAL;
		protected var _back:MovieClip;//滑动轨道背景
		protected var _trackBar:Button;
		protected var _changeHandler:Handler;
		
		public function Slider(skin:*):void {
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void {
			_back = getMcPath("track");
			_trackBar = new Button(getMcPath("btn_thumb"));
			_trackBar.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			allowBackClick = false;
		}
		
		protected function onButtonMouseDown(e:MouseEvent):void {
			AppCenter.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			AppCenter.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			if (_direction == VERTICAL) {
				(_trackBar.view as Sprite).startDrag(false, new Rectangle(_trackBar.x, 0, 0, height - _trackBar.height));
			} else {
				(_trackBar.view as Sprite).startDrag(false, new Rectangle(0, _trackBar.y, width - _trackBar.width, 0));
			}
		}
		
		protected function onStageMouseUp(e:MouseEvent):void {
			AppCenter.instance.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			AppCenter.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			(_trackBar.view as Sprite).stopDrag();
		}
		
		protected function onStageMouseMove(e:MouseEvent):void {
			var oldValue:Number = _value;
			if (_direction == VERTICAL) {
				_value = _trackBar.y / (height - _trackBar.height) * (_max - _min) + _min;
			} else {
				_value = _trackBar.x / (width - _trackBar.width) * (_max - _min) + _min;
			}
			_value = Math.round(_value / _tick) * _tick;
			if (_value != oldValue) {
				sendChangeEvent();
			}
		}
		
		protected function sendChangeEvent():void {
			sendEvent(Event.CHANGE);
			if (_changeHandler != null) {
				_changeHandler.executeWith([_value]);
			}
		}
		
		protected function changeSize():void {
//			super.changeSize();
			_back.width = width;
			_back.height = height;
			setBarPoint();
		}
		
		protected function setBarPoint():void {
			if (_direction == VERTICAL) {
				_trackBar.x = (_back.width - _trackBar.width) * 0.5;
			} else {
				_trackBar.y = (_back.height - _trackBar.height) * 0.5;
			}
		}
		
		protected function changeValue():void {
			_value = Math.round(_value / _tick) * _tick;
			_value = _value > _max ? _max : _value < _min ? _min : _value;
			if (_direction == VERTICAL) {
				_trackBar.y = (_value - _min) / (_max - _min) * (height - _trackBar.height);
			} else {
				_trackBar.x = (_value - _min) / (_max - _min) * (width - _trackBar.width);
			}
		}
		
		/**
		 * 设置滑值范围.
		 * @param min
		 * @param max
		 * @param value
		 * 
		 */
		public function setSlider(min:Number, max:Number, value:Number):void {
			_value = -1;
			_min = min;
			_max = max > min ? max : min;
			this.value = value < min ? min : value > max ? max : value;
		}
		
		/**刻度值,默认值为1,单位大小*/
		public function get tick():Number {
			return _tick;
		}
		
		public function set tick(value:Number):void {
			_tick = value;
			callLater(changeValue);
		}
		
		/**滑块上允许的最大值*/
		public function get max():Number {
			return _max;
		}
		
		public function set max(value:Number):void {
			if (_max != value) {
				_max = value;
				callLater(changeValue);
			}
		}
		
		/**滑块上允许的最小值*/
		public function get min():Number {
			return _min;
		}
		
		public function set min(value:Number):void {
			if (_min != value) {
				_min = value;
				callLater(changeValue);
			}
		}
		
		/**当前值*/
		public function get value():Number {
			return _value;
		}
		
		public function set value(num:Number):void {
			if (_value != num) {
				_value = num;
				changeValue();
				sendChangeEvent();
			}
		}
		
		/**滑动方向*/
		public function get direction():String {
			return _direction;
		}
		
		public function set direction(value:String):void {
			_direction = value;
		}
		
		/**允许点击后面*/
		public function get allowBackClick():Boolean {
			return _allowBackClick;
		}
		
		public function set allowBackClick(value:Boolean):void {
			if (_allowBackClick != value) {
				_allowBackClick = value;
				if (_allowBackClick) {
					_back.addEventListener(MouseEvent.MOUSE_DOWN, onBackBoxMouseDown);
				} else {
					_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackBoxMouseDown);
				}
			}
		}
		
		protected function onBackBoxMouseDown(e:MouseEvent):void {
			if (_direction == VERTICAL) {
				value = _back.mouseY / (height - _trackBar.height) * (_max - _min) + _min;
			} else {
				value = _back.mouseX / (width - _trackBar.width) * (_max - _min) + _min;
			}
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is Number || value is String) {
				this.value = Number(value);
			} else {
				super.dataSource = value;
			}
		}
		
		/**控制按钮*/
		public function get trackBar():Button {
			return _trackBar;
		}
		
		/**数据变化处理器*/
		public function get changeHandler():Handler {
			return _changeHandler;
		}
		
		public function set changeHandler(value:Handler):void {
			_changeHandler = value;
		}
		
	}
}