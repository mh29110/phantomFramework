package phantom.core.managers.render
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import phantom.core.events.UIEvent;
	import phantom.core.interfaces.IManager;
	
	/**渲染管理器*/
	public class RenderManager implements IManager
	{
		private var _methods:Dictionary = new Dictionary();
		private var _stage:Stage;	
		public function RenderManager() {
		}
		
		private function invalidate():void {
			if (_stage) {
				//render有一定几率无法触发，这里加上保险处理
				_stage.addEventListener(Event.ENTER_FRAME, onValidate);
				_stage.addEventListener(Event.RENDER, onValidate);
				_stage.invalidate();
			}
		}
		
		private function onValidate(e:Event):void {
			_stage.removeEventListener(Event.RENDER, onValidate);
			_stage.removeEventListener(Event.ENTER_FRAME, onValidate);
			renderAll();
			_stage.dispatchEvent(new Event(UIEvent.RENDER_COMPLETED));
		}
		
		public function register(stage:Stage):void {
			_stage = stage;
		}
		/**执行所有延迟调用*/
		public function renderAll():void {
			for (var method:Object in _methods) {
				exeCallLater(method as Function);
			}
			for each (method in _methods) {
				return renderAll();
			}
		}
		
		/**延迟调用*/
		public function callLater(method:Function, args:Array = null):void {
			if (_methods[method] == null) {
				_methods[method] = args || [];
				invalidate();
			}
		}
		
		/**执行延迟调用*/
		public function exeCallLater(method:Function):void {
			if (_methods[method] != null) {
				var args:Array = _methods[method];
				delete _methods[method];
				method.apply(null, args);
			}
		}
	}
}