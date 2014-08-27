package {
	import flash.utils.Dictionary;
	
	import phantom.core.consts.ManagerName;
	import phantom.core.interfaces.IManager;
	import phantom.core.managers.LoaderManager;
	import phantom.core.managers.LogManager;
	import phantom.core.managers.TimerManager;
	import phantom.core.managers.render.AssetManager;
	import phantom.core.managers.render.RenderManager;
	import phantom.core.managers.render.TipManager;
	
	/**
	 * 管理器中心, 提供服务,但不需要抛出事件.   // 区别于IMediator
	 * @author phantom
	 * 
	 */
	public class AppCenter {
		private var _managerMap:Dictionary;
		public function AppCenter()
		{
			_managerMap = new Dictionary();

			  _asset	= new AssetManager();
			  _loader	= new LoaderManager();
			  _timer 	= new TimerManager();
			  _log 		= new LogManager();
			  _tip 		= new TipManager();
			  addManager(_asset, ManagerName.ASSET);
			  addManager(_loader, ManagerName.LOADER);
			  addManager(_timer, ManagerName.TIMER);
			  addManager(_log, ManagerName.LOG);
			  addManager(_tip , ManagerName.TIP);
		}


		/**
		 * 添加管理器 
		 * @param manager  IManager
		 * @param name 
		 * @see phantom.core.ManagerName
		 * 
		 */
		public function addManager(manager:IManager,name:String):void 
		{
			if(name!=null && name !=""  && _managerMap[name] != null)
			{
				throw new Error("no id or  repetitive error");
			}
			else
			{
				_managerMap[name] = manager;
			}
		}
		
		/**
		 * 获取管理器 
		 * @param id
		 * @return 
		 * 
		 */
		public function getManager(name:String):IManager
		{
			return  IManager(_managerMap[name]);
		}
		
		
		/**获得资源路径(此处可以加上资源版本控制)*/
		public static function getResPath(url:String):String {
			return /^http:\/\//g.test(url) ? url : GlobalConfig.resPath + url;
		}
		
//--------   常见的管理器---getter /setter-----以成员变量的形式提取----	
		private static var _instance:AppCenter;


		private var _log:LogManager;

		private var _timer:TimerManager;

		private var _loader:LoaderManager;

		private var _asset:AssetManager;
		
		private var _tip:TipManager;
		
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
		
		public function get tip():TipManager
		{
			return _tip;
		}
		
		public function get render():RenderManager
		{
			return getManager(ManagerName.RENDER) as RenderManager;
		}

		//		private static var _dialog:DialogManager = new DialogManager();

	}
}