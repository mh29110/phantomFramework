package splash
{
	import flash.display.DisplayObjectContainer;
	
	import commands.consts.CommandListSystem;
	import commands.system.GameEnterCommand;
	import commands.system.GameStartupCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class AppFacade extends Facade
	{
		public function AppFacade()
		{
			super();
		}
		/**
		 * 这里仅仅定义Notification（通知）常量	--	STARTUP （private），标识应用程序启动
		 * 其它Notification（通知）常量抽离到ApplicationConstants中定义，这样更简洁、清晰
		 */
		private static const STARTUP:String = "startup";
		
		public static function getInstance():AppFacade
		{
			if (instance == null)
				instance = new AppFacade();
			return instance as AppFacade;
		}
		
		/**
		 * 为了是ApplicationFacade结构更清晰，简洁。
		 * 将注册Command、Proxy、View&Mediator的工作抽离到BootstrapCommands、BootstrapModels、BootstrapViewMediators去做。
		 *
		 * 注册应用程序启动Startup命令，应用程序启动时执行 StartupCommand
		 * StartupCommand中将执行以下操作：
		 * 		BootstrapCommands		--	初始化应用程序事件与Command之间的映射关系；
		 * 		BootstrapModels			--	Model 初始化，初始化应用程序启动过程中需要用到的Proxy，并注册；
		 * 		BootstrapViewMediators	--	View 初始化，唯一创建并注册ApplicationMediator，它包含其他所有View Component并在启动时创建它们
		 */
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(CommandListSystem.START_UP, GameStartupCommand);
			registerCommand(CommandListSystem.ENTER_GAME, GameEnterCommand);
			//            facade.registerCommand(CommandServerOrder.GET_PLAYER_INFO, GetPlayerInfoCommand);
			//            facade.registerCommand(CommandSystemOrder.ON_PLAYER_INFO_INITIALIZED, GameAssetPrepareCommand);
		}
		
		/**
		 * 启动PureMVC，在应用程序中调用此方法，并传递应用程序本身的引用
		 * @param	rootView	-	PureMVC应用程序的根视图root，包含其它所有的View Componet
		 */
		public function startUp(rootView:DisplayObjectContainer):void
		{
			//启动项目
			sendNotification( CommandListSystem.START_UP, rootView);
			sendNotification( CommandListSystem.ENTER_GAME);

			removeCommand(STARTUP); //PureMVC初始化完成，注销STARUP命令
		}
	}
}