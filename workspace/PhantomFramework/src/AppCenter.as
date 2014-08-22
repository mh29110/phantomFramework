package {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import phantom.core.managers.AssetManager;
	import phantom.core.managers.LoaderManager;
	import phantom.core.managers.LogManager;
	import phantom.core.managers.TimerManager;
	
	/**全局引用入口*/
	public class AppCenter {
		/**全局stage引用*/
		public static var stage:Stage;
		public function init(main:Sprite):void {
			stage = main.stage;
			stage.frameRate = GlobalConfig.GAME_FPS;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			
			//覆盖配置
			var gameVars:Object = stage.loaderInfo.parameters;
			if (gameVars != null) {
				for (var s:String in gameVars) {
					if (GlobalConfig[s] != null) {
						GlobalConfig[s] = gameVars[s];
					}
				}
			}
			installManagers();
//			stage.addChild(dialog);
//			stage.addChild(tip);
			stage.addChild(log);
		}
		
		private function installManagers():void
		{
			  _asset	= new AssetManager();
			  _loader	= new LoaderManager();
			  _timer 	= new TimerManager();
			  _log 		= new LogManager();
		}
		
		/**获得资源路径(此处可以加上资源版本控制)*/
		public static function getResPath(url:String):String {
			return /^http:\/\//g.test(url) ? url : GlobalConfig.resPath + url;
		}
		
		private static var _instance:AppCenter;

		private var _log:LogManager;

		private var _timer:TimerManager;

		private var _loader:LoaderManager;

		private var _asset:AssetManager;
		public static function get instance() : AppCenter
		{
			if (_instance == null)
			{
				_instance = new AppCenter ();    
			}
			return _instance;
		}

		/**资源管理器*/
		public function get asset():AssetManager
		{
			return _asset;
		}

		/**加载管理器*/
		public function get loader():LoaderManager
		{
			return _loader;
		}

		/**时钟管理器*/
		public function get timer():TimerManager
		{
			return _timer;
		}

		/**日志管理器*/
		public function get log():LogManager
		{
			return _log;
		}
		//		/**渲染管理器*/
		//		private static var _render:RenderManager = new RenderManager();
		//		/**对话框管理器*/
		//		private static var _dialog:DialogManager = new DialogManager();
		//		/**提示管理器*/
		//		private static var _tip:TipManager = new TipManager();
		//		/**拖动管理器*/
		//		private static var _drag:DragManager = new DragManager();
		//		/**语言管理器*/
		//		private static var _lang:LangManager = new LangManager();
		//		/**多线程加载管理器*/
		//		private static var _mloader:MassLoaderManager = new MassLoaderManager();
	

	}
}