package phantom.core.managers
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import phantom.core.interfaces.IManager;
	
	public class StageManager implements IManager
	{
		private var _stage:Stage;
		public function StageManager()
		{
		}
        public function register(main:Sprite):void {
			_stage = main.stage;
			_stage.frameRate = GlobalConfig.GAME_FPS;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.stageFocusRect = false;
			_stage.tabChildren = false;
			
			//覆盖配置
			var gameVars:Object = _stage.loaderInfo.parameters;
			if (gameVars != null) {
				for (var s:String in gameVars) {
					if (GlobalConfig[s] != null) {
						GlobalConfig[s] = gameVars[s];
					}
				}
			}
		}
		
		public function get stage():Stage
		{
			return _stage;
		}
		/**
		 * 默认的舞台高度(像素)
		 */ 
		public static const DEFAULT_GAME_SCREEN_WIDTH:int = 1248;
		
		/**
		 * 默认的舞台高度(像素)
		 */ 
		public static const DEFAULT_GAME_SCREEN_HEIGHT:int = 648;
		/**
		 * 最大的游戏屏幕宽度(像素)
		 */ 
		private const MAX_GAME_SCREEN_WIDTH:int = DEFAULT_GAME_SCREEN_WIDTH;
		
		/**
		 * 最大的游戏屏幕高度(像素)
		 */        
		private const MAX_GAME_SCREEN_HEIGHT:int = DEFAULT_GAME_SCREEN_HEIGHT;
		
		/**
		 * 当前的舞台高度(像素)
		 */ 
		private var _screenWidth:int;
		
		/**
		 * 当前的舞台高度(像素)
		 */ 
		private var _screenHeight:int;
		
		/**
		 * 当前的舞台宽度与默认的比例
		 */ 
		private var _gameScreenWidthRadio:Number;
		
		/**
		 * 当前的舞台高度与默认的比例
		 */ 
		private var _gameScreenHeightRadio:Number;
		
		/**
		 * 游戏屏幕宽度
		 */
		private var _gameScreenWidth:int;
		
		/**
		 * 游戏屏幕高度
		 */        
		private var _gameScreenHeight:int;
		
		private var _gameScreenOffsetY:int;
		
		private var _gameScreenOffsetX:int;
		
	
		/**
		 * 计算统计数据
		 */ 
		public function computeStats():void
		{
			_screenWidth = _stage.stageWidth;
			_screenHeight = _stage.stageHeight;
			
			_gameScreenWidth = Math.min(_screenWidth, DEFAULT_GAME_SCREEN_WIDTH);
			_gameScreenHeight = Math.min(_screenHeight, DEFAULT_GAME_SCREEN_HEIGHT);
			
			_gameScreenOffsetX = Math.floor((_screenWidth - DEFAULT_GAME_SCREEN_WIDTH)*.5);
			_gameScreenOffsetY = Math.floor((_screenHeight - DEFAULT_GAME_SCREEN_HEIGHT)*.5);
			
			_gameScreenWidthRadio = _gameScreenWidth/DEFAULT_GAME_SCREEN_WIDTH;
			_gameScreenHeightRadio = _gameScreenHeight/DEFAULT_GAME_SCREEN_HEIGHT;
		}
		
		/**
		 * 当前的游戏屏幕宽度与默认屏幕宽度的比例
		 */
		public function get gameScreenWidthRadio():Number
		{
			return _gameScreenWidthRadio;
		}
		
		/**
		 * 当前的游戏屏幕高度与默认屏幕高度的比例
		 */
		public function get gameScreenHeightRadio():Number
		{
			return _gameScreenHeightRadio;
			
		}
		
		/**
		 * 游戏屏幕宽度
		 */        
		public function get gameScreenWidth():int
		{
			return _gameScreenWidth;
		}
		
		/**
		 * 游戏屏幕高度
		 */        
		public function get gameScreenHeight():int
		{
			return _gameScreenHeight;
		}
		
		/**
		 * 当前的舞台宽度(像素)
		 */
		public function get screenWidth():int
		{
			return _screenWidth;
		}
		
		/**
		 * 当前的舞台高度(像素)
		 */
		public function get screenHeight():int
		{
			return _screenHeight;
		}
		
		/**
		 * 默认的舞台宽度(像素)
		 */
		public function get defaultScreenWidth():int
		{
			return DEFAULT_GAME_SCREEN_WIDTH;
		}
		
		/**
		 * 默认的舞台高度(像素)
		 */
		public function get defaultScreenHeight():int
		{
			return DEFAULT_GAME_SCREEN_HEIGHT;
		}
		
		public function get gameScreenOffsetX():int
		{
			return _gameScreenOffsetX;
		}
		
		public function get gameScreenOffsetY():int
		{
			return _gameScreenOffsetY;
		}
		
	}
}