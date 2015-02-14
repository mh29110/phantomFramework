package commands.system
{
	import commands.consts.CommandListSystem;
	
	import gamescene.Zest3d;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import phantom.core.consts.ManagerName;
	import phantom.core.handlers.Handler;
	import phantom.core.managers.LoaderManager;
	import phantom.core.managers.ResLoader;
	import phantom.core.managers.render.StageManager;
	
	import view.consts.ScreenUIDefine;
	
	/**
	 * 
	 * @author liphantomjia@gmail.com
	 * 
	 */
	public class GameEnterCommand extends SimpleCommand
	{
		private var _loader:LoaderManager;
		public function GameEnterCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			
			facade.sendNotification(CommandListSystem.OPEN_SCREEN, [ScreenUIDefine.MajorScreen]);
			
			/*var serv:Service = Service.instance;
			
			var busyIndicate:BusyIndicateService = serv.getService(ServiceGuids.BUSY_INDICATE_SERVICE) as BusyIndicateService;
			busyIndicate.switchToInGameMode();
			
			var stageServ:StageService = serv.getService(ServiceGuids.STAGE_SERVICE) as StageService;
			stageServ.currentStage.dispatchEvent(new SystemEvent(SystemEvent.GAME_CONTENT_INITIALIZED, true,true));
			
			var gdm:GameDataModule = serv.getService(ServiceGuids.GAME_DATA_MODULE_SERVICE) as GameDataModule;
			var networkServ:NetworkService = serv.getService(ServiceGuids.NETWORK_SERVICE) as NetworkService;
			var configServ:ConfigService = serv.getService(ServiceGuids.CONFIG_SERVICE) as ConfigService;
			var autoPathingServ:AutoPathingService = serv.getService(ServiceGuids.AUTO_PATHING_SERVICE) as AutoPathingService;
			
			var activityInfo:ISystemActivityInfo = gdm
			var tickBuff : TickBuffService = new TickBuffService(activityInfo.activityList, networkServ);
			Service.instance.addService(ServiceGuids.BUFF_TICK_SERVICE, tickBuff);
			Facade.getInstance().registerMediator(tickBuff);
			
			if(configServ.isBattlePlayerMode)
			{
				var params:Array = [];
				params[0] = configServ.replayBattleReportIds;
				if(configServ.replayBattleReportRounds)
				{
					params[1] = configServ.replayBattleReportRounds;
				}
				sendNotification(CommandGameOrder.SWITCH_GAME_SCENE, params,  GameModuleConsts.SCENE_BATTLE_PLAYER);
				return;
			}
			
			if(autoPathingServ)
			{
				facade.registerMediator(autoPathingServ);
			}
			
        	var majorScreen:MajorScreenControllerMediator = facade.retrieveMediator(UIScreenDefineConsts.MAJOR_SCREEN) as MajorScreenControllerMediator;
            if(majorScreen == null)
            {
                majorScreen = new MajorScreenControllerMediator();;
                facade.registerMediator(majorScreen);
            }
            sendNotification(CommandSystemOrder.OPEN_SCREEN, [UIScreenDefineConsts.WORLD_MAP_SCREEN]);
            sendNotification(CommandUIEffectOrder.FADE_OUT_COMPLETE);
			return;
			
			sendNotification(CommandGameOrder.BACK_TO_CITY, [false]);*/
			
			//显示主场景
			var app:AppCenter = AppCenter.instance;
			_loader = app.getManager(ManagerName.LOADER) as LoaderManager;
			_loader.loadAssets([{url:"assets/3ds/dancer.3ds",type:ResLoader.BYTE,size:100},
								{url:"assets/3ds/crate.3ds",type:ResLoader.BYTE,size:100},
								{url:"assets/3ds/Rikku.3ds",type:ResLoader.BYTE,size:100},
								{url:"assets/3ds/witcher.3ds",type:ResLoader.BYTE,size:100},
								{url:"assets/atf/toon_gradient2.atf",type:ResLoader.BYTE,size:100},
								{url:"assets/atf/space.atf",type:ResLoader.BYTE,size:100},
								{url:"assets/atf/bw_checked.atf",type:ResLoader.BYTE,size:100},
								{url:"assets/particle.atf",type:ResLoader.BYTE,size:100},
								{url:"assets/atfcube/skybox.atf",type:ResLoader.BYTE,size:100},
								{url:"assets/cove.atf",type:ResLoader.BYTE,size:50}],
								new Handler(onLoadedHandler));
		}
		
		private function onLoadedHandler():void
		{
			var stageManager:StageManager = AppCenter.instance.getManager(ManagerName.STAGE) as StageManager;
			
			var zest:Zest3d = new Zest3d();
			stageManager.stage.addChild(zest); 
			//占位符加载
		}
		
	}
}