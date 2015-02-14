package phantom.core.managers.render
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import phantom.core.consts.ManagerName;
	import phantom.core.interfaces.IManager;
	import phantom.core.utils.Stats;
	
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
			
			initLayers();//如果所有层次都确定,就不需要这些占位符了.
		
			addToLayerAt(AppCenter.instance.log.toggle(),LOG_LAYER,false);
//			addToLayerAt(AppCenter.instance.dialog,DIALOG_LAYER);
			addToLayerAt(AppCenter.instance.tip,TIP_LAYER,false);

			// debug stats  panel
			var stats:Stats = new Stats();
			_stageContainer.addChild(stats);
			onResize();
		}
		
		public function addToLayerAt(display:DisplayObject,zdeep:int,closeOther:Boolean):void
		{
			var layer:Sprite = _stageContainer.getChildAt(zdeep) as Sprite;
			if (closeOther) {
				removeAllChild(layer);
			}
			layer.addChild(display);
		}
		
		/**删除所有子显示对象
		 * @param except 例外的对象(不会被删除)*/
		public function removeAllChild(container:Sprite):void {
			var numChildren:int = container.numChildren;
			for (var i:int = numChildren - 1; i > -1; i--) {
				container.removeChildAt(i);
			}
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