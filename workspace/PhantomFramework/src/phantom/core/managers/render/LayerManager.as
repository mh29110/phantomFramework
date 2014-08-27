package phantom.core.managers.render
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import phantom.core.consts.ManagerName;
	import phantom.core.interfaces.IManager;
	
	public class LayerManager implements IManager
	{
		/**
		 * 所有图层的父容器 
		 */
		private var _stageContainer:Sprite;
		
		private var _stage:Stage;
		
		public function LayerManager(stage:Stage)
		{
			_stage = stage;
			
			initialize();
		}
		
		private function initialize():void
		{
			_stageContainer = new Sprite();
			_stage.addChild(_stageContainer);
			
			initLayers();
		
			addToLayerAt(AppCenter.instance.log.toggle(),LOG_LAYER);
			addToLayerAt(AppCenter.instance.tip,TIP_LAYER);

			onResize();
		}
		
		public function addToLayerAt(display:DisplayObject,zdeep:int):void
		{
			var layer:Sprite = _stageContainer.getChildAt(zdeep) as Sprite;
			layer.addChild(display);
		}
		
		private function onResize():void
		{
			var stageManager:StageManager = AppCenter.instance.getManager(ManagerName.STAGE) as StageManager;
			_stageContainer.scrollRect = new Rectangle(0, 0, stageManager.gameScreenWidth,stageManager.gameScreenHeight);
		}
//---------------------consts  of  layers -----------------------
		private const MAX_NUM:uint = 10;
		public static const SCREEN_LAYER:uint = 0;
		public static const DRAG_LAYER:uint = 1;
		public static const DIALOG_LAYER:uint = 2;
		public static const EFFECT_LAYER:uint = 3;
		public static const LOG_LAYER:uint = 4;
		public static const TIP_LAYER:uint = 6;
		
		private function initLayers():void
		{
			var layer:Sprite;
			for (var i:int = 0; i < MAX_NUM; i++) 
			{
				layer = new Sprite();
				_stageContainer.addChild(layer);
			}
			
			
		}
		
		
	}
}