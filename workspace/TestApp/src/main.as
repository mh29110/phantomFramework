package
{
	import com.hujue.manager.PopUpManager;
	import com.hujue.manager.StageProxy;
	import com.hujue.utils.Reflection;
	
	import common.debug.Fps;
	import common.loader.LoaderItem;
	import common.loader.ResLoader;
	import common.source.DelayloadedManager;
	import common.source.LocalCacheEvent;
	import common.source.LocalCacheManager;
	import common.source.ResourceStatus;
	import common.timer.TimerManager;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import hsxyGame.control.AchievementController;
	import hsxyGame.control.ActivityController;
	import hsxyGame.control.AnswerController;
	import hsxyGame.control.ArenaController;
	import hsxyGame.control.AuctionController;
	import hsxyGame.control.AutoMFController;
	import hsxyGame.control.BackgroundSoundController;
	import hsxyGame.control.BagController;
	import hsxyGame.control.BagFilterControl;
	import hsxyGame.control.BattlegroundController;
	import hsxyGame.control.BattlegroundShopController;
	import hsxyGame.control.BeastFightingController;
	import hsxyGame.control.BuildController;
	import hsxyGame.control.ButtomController;
	import hsxyGame.control.ChangeLineController;
	import hsxyGame.control.ChangeSexController;
	import hsxyGame.control.ChatController;
	import hsxyGame.control.ControlInitUtil;
	import hsxyGame.control.DailyTaskController;
	import hsxyGame.control.DebugController;
	import hsxyGame.control.DemonTowerController;
	import hsxyGame.control.DemonTowerShopController;
	import hsxyGame.control.DialogController;
	import hsxyGame.control.DigMineController;
	import hsxyGame.control.DoubleCultivationController;
	import hsxyGame.control.DoubleExpController;
	import hsxyGame.control.DropPackController;
	import hsxyGame.control.DungenoController;
	import hsxyGame.control.EnthrallmentController;
	import hsxyGame.control.FightValueController;
	import hsxyGame.control.FigureController;
	import hsxyGame.control.FirstBloodController;
	import hsxyGame.control.FreshmanGuideController;
	import hsxyGame.control.FriendController;
	import hsxyGame.control.GenmaFBController;
	import hsxyGame.control.GodEvilFightingController;
	import hsxyGame.control.GuildBlessingController;
	import hsxyGame.control.GuildChatController;
	import hsxyGame.control.GuildController;
	import hsxyGame.control.GuildRewardsController;
	import hsxyGame.control.GuildWareHouseController;
	import hsxyGame.control.GymkhanaController;
	import hsxyGame.control.HonorShopController;
	import hsxyGame.control.HorseController;
	import hsxyGame.control.HotSpringController;
	import hsxyGame.control.InfoGoodsController;
	import hsxyGame.control.KaiFuActivityController;
	import hsxyGame.control.LoginController;
	import hsxyGame.control.LoveController;
	import hsxyGame.control.LuckyBagController;
	import hsxyGame.control.MailController;
	import hsxyGame.control.MainController;
	import hsxyGame.control.MallController;
	import hsxyGame.control.MapController;
	import hsxyGame.control.MarryController;
	import hsxyGame.control.MentoringController;
	import hsxyGame.control.MeridianController;
	import hsxyGame.control.MysteriousShopController;
	import hsxyGame.control.NoticeController;
	import hsxyGame.control.NoviceGuideController;
	import hsxyGame.control.OffLineController;
	import hsxyGame.control.OnlinePresentsController;
	import hsxyGame.control.PetController;
	import hsxyGame.control.PhaseController;
	import hsxyGame.control.PresentsController;
	import hsxyGame.control.RankController;
	import hsxyGame.control.RoleController;
	import hsxyGame.control.RunTradeController;
	import hsxyGame.control.SceneController;
	import hsxyGame.control.SceneEffectController;
	import hsxyGame.control.SceneFaceController;
	import hsxyGame.control.SealController;
	import hsxyGame.control.SerGymkSingleController;
	import hsxyGame.control.ServerGymkController;
	import hsxyGame.control.SettingController;
	import hsxyGame.control.ShiZhuangShopController;
	import hsxyGame.control.ShopController;
	import hsxyGame.control.ShortCutController;
	import hsxyGame.control.SiegeBattleController;
	import hsxyGame.control.SingleCopyController;
	import hsxyGame.control.SkillController;
	import hsxyGame.control.SpecialEffectController;
	import hsxyGame.control.StatisticsController;
	import hsxyGame.control.SubWeaponController;
	import hsxyGame.control.SystemMessageController;
	import hsxyGame.control.TaskController;
	import hsxyGame.control.TaskFollowController;
	import hsxyGame.control.TeamController;
	import hsxyGame.control.TrainPracticeController;
	import hsxyGame.control.TransactionController;
	import hsxyGame.control.TransferController;
	import hsxyGame.control.VIPSystemController;
	import hsxyGame.control.WareHouseController;
	import hsxyGame.control.farmControl.FarmSceneController;
	import hsxyGame.events.ParamEvent;
	import hsxyGame.manager.LayerManager;
	import hsxyGame.manager.PopManage;
	import hsxyGame.model.backpack.vo.GoodsBasic;
	import hsxyGame.model.common.GameManager;
	import hsxyGame.model.config.ConfigManager;
	import hsxyGame.model.scene.vo.ElementVo;
	import hsxyGame.model.scene.vo.SceneInfoVo;
	import hsxyGame.socket.CustomSocket;
	import hsxyGame.socket.command.s10.SCMD10000;
	import hsxyGame.socket.command.s10.SCMD10005;
	import hsxyGame.utils.BlockWordHelper;
	import hsxyGame.utils.GongGaoUtil;
	import hsxyGame.utils.ParseXMLUtil;
	import hsxyGame.utils.RabotDefend;
	import hsxyGame.view.GameView;
	import hsxyGame.view.demontower.CDEffect;
	import hsxyGame.view.globel.MouseCursor;
	import hsxyGame.view.scene.Treasure;
	
	import hsxyUI.Alert;
	import hsxyUI.ComponentManager;
	import hsxyUI.Loading;
	import hsxyUI.Message;
	import hsxyUI.ResLoading;
	
	import zip.asmax.util.ZipReader;

	//	设置影片的宽度 高度  帧频 width="1000" , height="580" , 
	[SWF( frameRate = "29" , backgroundColor = "0x000000" , width = "1000" , height = "620" )]
	public class main extends Sprite
	{
		public var loading:ResLoading;
		private static var _instance:main;
		private var loader:ResLoader;
		private var _robotDefend:RabotDefend;

		public function main()
		{
			trace( "main App Init!" );
			this.addEventListener( Event.ADDED_TO_STAGE , adderHandler );
			_instance = this;
			loading = ResLoading.getInstance();
//			startFakeLoading();

		
			
			
		}

		private function adderHandler( e:Event ):void
		{
			/*			if(GameLoader.loading.parent)
						GameLoader.loading.parent.removeChild(GameLoader.loading);*/
			this.removeEventListener( Event.ADDED_TO_STAGE , adderHandler );
			registerClassAlias( "vo.SceneInfoVo" , SceneInfoVo );
			registerClassAlias( "vo.ElementVo" , ElementVo );
			registerClassAlias( "Dictionary" , Dictionary );
			registerClassAlias( "GoodsBasic" , GoodsBasic );
			registerClassAlias( "point" , Point );

			var game:GameView = new GameView();
			addChild( game );

			stage.stageFocusRect = false;
			StageProxy.registed( this.stage );

			PopUpManager.layer = LayerManager.topLayer;
			LayerManager.resLoadingLayer.addChild( hsxyLoader.loading );
			this.loaderInfo.addEventListener( Event.COMPLETE , completeInfoHandler );
			loading = hsxyLoader.loading;
//			loading.setProgress(25,100);
			loading.setText( "正在启动程序" );

			
			
			ComponentManager.init();

			Security.allowDomain( "*" );
			LoginController.getInstance();
			ChangeLineController.getInstance();
//			completeInfoHandler();
		}

		private function completeInfoHandler( e:Event = null ):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			loaderInfo.removeEventListener( Event.COMPLETE , completeInfoHandler );
			var mainController:MainController = MainController.getInstance();
			mainController.startSocket();
			loading.setText( "游戏启动中" );
			loadResource();
		}
		

		/**
		 *
		 * 提取登录信息
		 * @parame 登陆帐号信息
		 * return object 登陆信息对象
		 *
		 */
		public function getLoginInfo( _url:String ):Object
		{
			var obj:Object = new Object();
			var r1:RegExp = /accid=/i
			var index1:int = _url.search( r1 );
			var r2:RegExp = /accname=/i
			var index2:int = _url.search( r2 );
			var begin:int = index1 + 6;
			var end:int = index2 - 1 - begin;
			obj.accid = int( _url.substr( begin , end ));

			var r3:RegExp = /tstamp=/i
			var index3:int = _url.search( r3 );
			begin = index2 + 8;
			end = index3 - 1 - begin;
			obj.accname = _url.substr( begin , end );

			var r4:RegExp = /ticket=/i
			var index4:int = _url.search( r4 );
			begin = index3 + 7;
			end = index4 - 1 - begin;
			obj.tstamp = int( _url.substr( begin , end ));
			obj.ticket = _url.substr( index4 + 7 );

			return obj;
		}

		public function getLoginInfo2( _url:String ):Object
		{
			var obj:Object = new Object();

			var strArr:Array = _url.split( "&" );
			for each ( var str:String in strArr )
			{
				obj[ str.split( "=" )[ 0 ]] = str.split( "=" )[ 1 ];
			}
			return obj;
		}

		/**
		 * 加载素材
		 *
		 */
		private function loadResource():void
		{
			loader = new ResLoader();
			var a:XML = ConfigManager.configData;
			var swfList:XMLList = ConfigManager.assetsData.swf.children();
			var xmlList:XMLList = ConfigManager.assetsData.xml.children();
			var i:int;
			var info:Object;
			var root:String = ConfigManager.root;

			if ( ConfigManager.isTest )
			{
				for ( i = 0 ; i < xmlList.length() ; i++ )
				{
					info = new Object();
					info.type = "xml";
					info.name = xmlList[ i ].@name;
					info.title = xmlList[ i ].@title;
					info.url = root + "assets/config/" + xmlList[ i ].toString();
					loader.addItem( new LoaderItem( info.url , info ));
				}
			}
			else
			{
				info = new Object(); /////加载配置文件包
				info.type = "zip";
				info.name = "配置文件";
				info.title = "配置文件包";
				info.url = "assets/config/config.hsxy";
				loader.addItem( new LoaderItem( info.url , info ));
			}
			for ( i = 0 ; i < swfList.length() ; i++ )
			{
				info = new Object();
				info.type = "swf";
				info.name = swfList[ i ].@name;
				info.title = swfList[ i ].@title;
				info.url = swfList[ i ].toString();
				loader.addItem( new LoaderItem( info.url , info ));
			}
			loader.addEventListener( ResLoader.COMPLETE , queueCompleteHandler );
			loader.addEventListener( ResLoader.ITEM_COMPLETE , itemCompleteHandler );
			loader.addEventListener( ResLoader.SINGLE_PROGRESS , singleProgressHandler )
			loader.addEventListener( ResLoader.ITEM_START , itemStartHandler );
			loader.load();
		}

		private function singleProgressHandler( e:ParamEvent ):void
		{
			var obj:Object = e.param;
			loading.setProgressSingle( obj.bytesLoaded , obj.bytesTotal );
			
		}

		/**
		 *
		 * 完成加载素材
		 * @param e
		 *
		 */
		private function queueCompleteHandler( e:ParamEvent ):void
		{
			//			loading.setProgressTxt( 100 );
			loading.setText( "获取场景信息！" );
			e.target.removeEventListener( ResLoader.COMPLETE , queueCompleteHandler );
			e.target.removeEventListener( ResLoader.ITEM_COMPLETE , itemCompleteHandler );
			e.target.removeEventListener( ResLoader.ITEM_START , itemStartHandler );
			//			loadStepResource();
			applicationStart();
			setLoaderProgress();
		}


		private var curProgress:int;

		private function setLoaderProgress():void
		{
			curProgress = 90;
			TimerManager.getInstance().add( 500 , timerHandler )

			function timerHandler():void
			{
				curProgress = curProgress + Math.random() * 3;
				if ( loading )loading.setProgress( curProgress , 100 );
				if ( curProgress > 100 )
					TimerManager.getInstance().remove( timerHandler );
			}

			
		}

		/**
		 * 解析配置文件
		 * */
		private function parseXML():void
		{
			var xmlList:XMLList = ConfigManager.assetsData.xml.children();
			var zipData:ZipReader = ConfigManager.zip;
			for ( var i:int = 0 ; i < xmlList.length() ; i++ )
			{
				var title:String = xmlList[ i ].@title + "";
				
				ParseXMLUtil.parseXMLData(title,zipData.getFile( xmlList[ i ]));
			}
		}

		/**
		 * 開始加载一个队列的素材
		 * @param e
		 *
		 */
		private var a:int;

		private function itemStartHandler( e:ParamEvent ):void
		{
			loading.setText( "正在加载" + e.param.info.title );
		}

		private var _isCreateLoaded:Boolean;

		public function showCreate():void
		{
			if ( _isCreateLoaded && !_isShowCreate )
			{
				_isShowCreate = true;
//				MainController.getInstance().showCreateRole();
			}
			else
			{
				setTimeout( showCreate , 3000 );
			}
		}

		private var _isLinkBroke:Boolean;

		/**
		 * 是否已经断开链接
		 * @return
		 *
		 */
		public function get isLinkBroke():Boolean
		{
			return _isLinkBroke;
		}

		public function set isLinkBroke( value:Boolean ):void
		{
			_isLinkBroke = value;
			if ( value )
			{
				loader.stopLoad();
			}
		}


		/**
		 * 完成加载一个队列的素材
		 * @param e
		 *
		 */
		private function itemCompleteHandler( e:ParamEvent ):void
		{
			DelayloadedManager.getInstance().put( e.param.url );
			if ( isLinkBroke )
			{
				return;
			}
			var index:Number = loader.getProgress() - loader.getTotal() * 0.30 > 0 ? loader.getProgress() - loader.getTotal() * 0.30 : 0;
			loading.setProgress( loader.getTotal() * 0.20 + index , loader.getTotal());

			if ( e.param.info == null )
			{
				return;
			}
			if ( e.param.info.type == "zip" )
			{
				ConfigManager.zip = new ZipReader( ByteArray( e.param.content ));
				parseXML();
			}
			ParseXMLUtil.parseXMLData(e.param.info.title , e.param.content );
		}

		/**
		 *登录是是否有角色
		 */
		private var _hasRole:Boolean;
		/**
		 *是否在加载过程中显示了注册界面
		 */
		private var _isShowCreate:Boolean;

		private function applicationStart():void
		{
			trace( "_____________________________applicationStart" );
			if ( ConfigManager.parameters.dd == 1 )
			{
				DebugController.getInstance().initUI();
			}
			SceneController.getInstance();
			
			//添加鼠标
			this.stage.addChild( MouseCursor.getInstance());
			
			SceneEffectController.getInstance(); //场景效果控制器
			
			TrainPracticeController.getInstance();
			PopManage.getInstance();
			StatisticsController.getInstance();
			RoleController.getInstance();
			
			/** 活动列表面板 激活 */
			ActivityController.getInstance();
			
			ButtomController.getInstance();
			SystemMessageController.getInstance();
			/** 激活[背包]，[任务]，[邮件],[坐骑]的控制层 */
			
			
			TaskController.getInstance();
			DigMineController.getInstance();
			//			EmailController.getInstance();
			FigureController.getInstance();
			ShopController.getInstance();
			PetController.getInstance();
			FriendController.getInstance();
			SkillController.getInstance();
			BuildController.getInstance();
			PhaseController.getInstance();
			ShortCutController.getInstance();
			WareHouseController.getInstance();
			AuctionController.getInstance(); // 拍卖
			GuildController.getInstance();
			GuildWareHouseController.getInstance();
			
			SubWeaponController.getInstance();
			MapController.getInstance();
			AutoMFController.getInstance();
			NoticeController.getInstance();
			DialogController.getInstance();
			TaskFollowController.getInstance();
			ChatController.getInstance();
			
			MailController.getInstance();
			MallController.getInstance();
			TeamController.getInstance();
			GenmaFBController.getInstance();
			RankController.getInstance();
			DropPackController.getInstance();
			MeridianController.getInstance();
			InfoGoodsController.getInstance();
			TransactionController.getInstance();
			MentoringController.getInstance();
			EnthrallmentController.getInstance();
			SealController.getInstance();
			OffLineController.getInstance();
			BackgroundSoundController.getInstance();
			PresentsController.getInstance();
			OnlinePresentsController.getInstance();
			
			SettingController.getInstance();
			
			NoviceGuideController.getInstance();
			TransferController.getInstance();
			DailyTaskController.getInstance();
			GymkhanaController.getInstance();
			//屏蔽跨服战ServerGymkController.getInstance();
			//屏蔽跨服战2SerGymkSingleController.getInstance();
			DoubleExpController.getInstance();
			
			HonorShopController.getInstance();
			DungenoController.getInstance();
			VIPSystemController.getInstance();
			
			BattlegroundShopController.getInstance();
			BattlegroundController.getInstance();
			AnswerController.getInstance();
			RunTradeController.getInstance();
			
			GameManager.getInstance().isLoadComplete = true;
			
			DemonTowerController.getInstance();
			DemonTowerShopController.getInstance();
			
			
			BagFilterControl.getInstance();
			SpecialEffectController.getInstance();
			FarmSceneController.getInstance();
			FreshmanGuideController.getInstance();
			LoveController.getInstance();
			
			ShiZhuangShopController.getInstance();
			GuildRewardsController.getInstance();
			
			AchievementController.getInstance();
			HotSpringController.getInstance();
			
			ChangeSexController.getInstance();
			//			BuildDirectController.getInstance();
			
			GuildBlessingController.getInstance(); //帮派祝福
			GuildChatController.getInstance(); //帮派聊天
			DoubleCultivationController.getInstance(); //双修
			KaiFuActivityController.getInstance(); //开服活动
			FightValueController.getInstance(); //战斗力
			
			GodEvilFightingController.getInstance(); //妖界之门
			SiegeBattleController.getInstance(); //攻城战
			//屏蔽结婚MarryController.getInstance();
			HorseController.getInstance(); //坐骑
			MysteriousShopController.getInstance(); //神秘商城
			SingleCopyController.getInstance();
			ArenaController.getInstance(); //个人竞技场
			
			BeastFightingController.getInstance(); //坐骑争霸
			SceneFaceController.getInstance();  //场景表情
			BagController.getInstance();
			
			LuckyBagController.getInstance();  //鸿福礼包
			
			FirstBloodController.getInstance();//首冲礼包
			
			
			goAfterLoading();
			
			/*
			添加是否已注册判断后，这里排除
			if ( GameManager.getInstance().firstLogin == false )
			{*/
			//			if ( ChangeLineManager.getInstance().currentLine == -1 )
			//			{
			//				MainController.getInstance().sendLineListRequest();
			//			}
			//			else
			//			{
			//				LoginController.getInstance().sendRequestRoleList();
			//			}
			/*}*/
			if ( ConfigManager.isTest == true )
			{
				var fps:Fps = new Fps();
				fps.x = 70;
				fps.y = 200;

				addChild( fps );
			}

			_robotDefend = new RabotDefend();
			_robotDefend.addEventListener( RabotDefend.TIME_OUT , onTimeOut );
		}

		/**
		 *
		 * 资源加载结束
		 *
		 */
		public function goAfterLoading():void
		{

			MainController.getInstance().afterLoading( _isShowCreate );
		}

		private function onTimeOut( evt:Event = null ):void
		{
			if ( CustomSocket.getInstance().mainSocket.connected )
			{
				Alert.show( "游戏异常，断开连接！请重新连接。" , "" , 0 , okFunction );
				CustomSocket.getInstance().close();
			}
		}

		private function okFunction():void
		{
			if ( ExternalInterface.available )
				ExternalInterface.call( "location.reload" );
		}

		public static function getInstance():main
		{
			return _instance;
		}

	}
}


