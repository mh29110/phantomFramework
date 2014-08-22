package {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import phantom.core.handlers.Handler;
	import phantom.core.managers.AssetManager;
	import phantom.core.managers.LoaderManager;
	import phantom.core.managers.LogManager;
	import phantom.core.managers.TimerManager;
	
	/**全局引用入口*/
	public class App {
		/**全局stage引用*/
		public static var stage:Stage;
		/**资源管理器*/
		public static var asset:AssetManager = new AssetManager();
		/**加载管理器*/
		public static var loader:LoaderManager = new LoaderManager();
		/**时钟管理器*/
		public static var timer:TimerManager = new TimerManager();
//		/**渲染管理器*/
//		public static var render:RenderManager = new RenderManager();
//		/**对话框管理器*/
//		public static var dialog:DialogManager = new DialogManager();
		/**日志管理器*/
		public static var log:LogManager = new LogManager();
//		/**提示管理器*/
//		public static var tip:TipManager = new TipManager();
//		/**拖动管理器*/
//		public static var drag:DragManager = new DragManager();
//		/**语言管理器*/
//		public static var lang:LangManager = new LangManager();
//		/**多线程加载管理器*/
//		public static var mloader:MassLoaderManager = new MassLoaderManager();
		
		public static function init(main:Sprite):void {
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
			
//			stage.addChild(dialog);
//			stage.addChild(tip);
			stage.addChild(log);
			
			//如果UI视图是加载模式，则进行整体加载
			if (Boolean(GlobalConfig.uiPath)) {
				App.loader.loadDB(GlobalConfig.uiPath, new Handler(onUIloadComplete));
			}
		}
		
		private static function onUIloadComplete(content:*):void {
//			View.xmlMap = content;
			
			trace("load complete");
		}
		
		/**获得资源路径(此处可以加上资源版本控制)*/
		public static function getResPath(url:String):String {
			return /^http:\/\//g.test(url) ? url : GlobalConfig.resPath + url;
		}
	}
}