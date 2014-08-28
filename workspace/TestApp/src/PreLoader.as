package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import phantom.core.consts.ManagerName;
	import phantom.core.handlers.Handler;
	import phantom.core.managers.render.RenderManager;
	import phantom.core.managers.render.StageManager;
	
	import splash.VersionSprite;
	
	[SWF(width="1248", height="648", backgroundColor="0x0")]
	public class PreLoader extends VersionSprite
	{
		[Embed(source="../bin-debug/assets/loadingUnderAssets.swf", mimeType="application/octet-stream")]
		private static var _loadingUnder:Class;
		
		/**
		 * false 不放（防沉迷已通过） true 防沉迷状态
		 */
		private var _protectedSelected:Boolean;
		
		private var _needFcm:Boolean;
		
		protected var _loadingBarLoader:Loader;
		
		protected var _percentBar:MovieClip;
		
		private var _initialized:Boolean;
		
		public function PreLoader()
		{
			if(stage)
			{
				onAddToStage();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			}
		}
		
		private function onAddToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUnCaughtErrorEventHandle);
			
			stage.addEventListener(Event.RESIZE, onResize);
			
			var app:AppCenter = AppCenter.instance;
			var stageManager:StageManager = new StageManager();
			app.addManager(stageManager,ManagerName.STAGE);
			stageManager.register(this);
			var renderManager:RenderManager = new RenderManager();
			app.addManager(renderManager,ManagerName.RENDER);
			renderManager.register(this);

			
			// pattern one  flash vars  - by uqee.com
			var flashvars:Object = root.loaderInfo.parameters;
			var len:int;
			if(flashvars.version)
			{
				//					var configServ:ConfigService = new ConfigService();
				//					configServ.parseFlashVars(flashvars);
				//					serv.addService(ServiceGuids.STAGE_SERVICE, configServ);
			}
			
			// pattern two url    - by qunyu		
			var url:String = this.loaderInfo.url;
			//ConfigManager.currentDomainUrl=url;
			
			onResize();
		}
		
		private function onResize(e:Event = null):void
		{
			initialize();
			var stageManager:StageManager = StageManager(AppCenter.instance.getManager(ManagerName.STAGE));
			stageManager.computeStats();
			var tx:int = stageManager.gameScreenOffsetX;
			var ty:int = stageManager.gameScreenOffsetY;
			this.x = tx;
			this.y = ty;
		}
		
		//uqee.com - php传flashvars 
		private static const EXTERNALCALL_URL_PARAMS:String = "getUrlParams";
		private static const UQEE_MYCS_BATTLE_PLAYER_MODE:String = "reportid"
		private static const UQEE_MYCS_URL_BACKGATE:String = "d_l";
		private static const UQEE_MYCS_URL_REFRESH_KEY:String = "skey";
		
		private static const EXTERNALCALL_COOKIE_PARAMS:String = "getLoginParams";
		private static const UQEE_MYCS_COOKIE_CHARGE_PAGE:String = "charge";
		private static const UQEE_MYCS_COOKIE_PLATFORM:String = "platform";
		private static const UQEE_MYCS_COOKIE_SOURCE:String = "source";
		private static const UQEE_MYCS_COOKIE_LOGIN_NAME:String = "loginname";
		private static const UQEE_MYCS_COOKIE_TIME_STAMP:String = "timestamp";
		private static const UQEE_MYCS_COOKIE_FCM:String = "fcm";
		private static const UQEE_MYCS_COOKIE_LOGIN_SERVICES:String = "logserv";
		private static const UQEE_MYCS_COOKIE_SERVER_ID:String = "serverid";
		
		private static const UQEE_MYCS_DEFAULT_LOGIN_SERVICES:String = "state.php";
		
		private var _chargePage:String;
		
		private var _registerStat:String;
		
		private var _source:String;
		
		private var _platform:String;
		
		private var _serverId:String;
		
		private var _name:String;
		
		private var _psw:String;
		private function initialize():void
		{
			if(_initialized)
			{
				return;
			}
			
			visible = true;
			_initialized = true;
			
			var showDebugLogin:Boolean
			if(Capabilities.playerType == "StandAlone")
			{
				showDebugLogin = true;
			}
			
			if(ExternalInterface.available)
			{
				var params:Object;
				params = ExternalInterface.call(EXTERNALCALL_URL_PARAMS);
				
				if(params.hasOwnProperty(UQEE_MYCS_BATTLE_PLAYER_MODE))
				{
					initLoadingBar();
					return;
				}
				
				if(params.hasOwnProperty(UQEE_MYCS_URL_BACKGATE) && int(params[UQEE_MYCS_URL_BACKGATE]) == 3)
				{
					showDebugLogin = true;
				}
				else
				{
					params = ExternalInterface.call(EXTERNALCALL_COOKIE_PARAMS);
					_chargePage = params[UQEE_MYCS_COOKIE_CHARGE_PAGE];
					_name = params[UQEE_MYCS_COOKIE_LOGIN_NAME];;
					_source = params[UQEE_MYCS_COOKIE_SOURCE];
					_platform = params[UQEE_MYCS_COOKIE_PLATFORM];
					_needFcm = !Boolean(int(params[UQEE_MYCS_COOKIE_FCM]));
					_registerStat = params[UQEE_MYCS_COOKIE_LOGIN_SERVICES];
					_serverId = params[UQEE_MYCS_COOKIE_SERVER_ID];
					
					if(!_registerStat)
					{
						_registerStat = UQEE_MYCS_DEFAULT_LOGIN_SERVICES;
					}
					
					initLoadingBar();
				}
				
			}
			
			if(showDebugLogin)
			{
				_registerStat = UQEE_MYCS_DEFAULT_LOGIN_SERVICES;
				initDebugLogin();
			}
		}
		
		private function initLoadingBar():void
		{
			removeChildren();
			
			var needFCM:String;
			if(_needFcm)
			{
				needFCM = "y";
			}
			else
			{
				needFCM = "n";
			}
			
			topGlobal.loginName = _name;
			topGlobal.loginPSW = _psw;
			topGlobal.needFCM = needFCM;
			topGlobal.source = _source;
			topGlobal.platform = _platform;
			topGlobal.registerStat = _registerStat;
			topGlobal.serverId = _serverId;
			if(_chargePage)
			{
				topGlobal.chargePage = _chargePage;
			}
			
			_loadingBarLoader = new Loader();
			_loadingBarLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, startLoadGame);
			_loadingBarLoader.loadBytes(new _loadingUnder() as ByteArray);
		}
		
		private function startLoadGame(e:Event):void
		{
			_percentBar = _loadingBarLoader.content['loadingLabel'];
			_percentBar.stop();
			addChild(_percentBar);
			
			var loadServDebugMode:Boolean = false;
			
			onGameLoadProgress(0);
			
			AppCenter.instance.loader.loadBYTE( "Initializer.swf?" + currentVersion, new Handler(onGameLoaded),new Handler( onGameLoadProgress),new Handler( onGameLoadError));
		}
		
		private function onGameLoadError(content:*):void
		{
			var _error:TextField = new TextField();
			_error.text = "加载游戏失败,请按'F5'刷新重试";
			_error.mouseEnabled = false;
			
			var tf:TextFormat = new TextFormat();
			tf.size = 18;
			tf.color= 0xffffff;
			tf.bold =true;
			tf.font="Arial";
			_error.setTextFormat(tf);
			_error.autoSize = TextFieldAutoSize.LEFT;
			_error.x = (stage.stageWidth-_error.textWidth)>>1;
			_error.y = 50+(stage.stageHeight-_error.textHeight)>>1;
			_error.filters = [new DropShadowFilter(0,0,0,1,3,3,8)];
			addChild(_error);
			disposeGameLoader();
		}
		
		private function onGameLoadProgress(value:Number):void
		{
			var percent:int = int(value*100);
			if(_percentBar.currentFrame!= percent)
			{
				_percentBar.gotoAndStop(percent);
			}
		}
		
		private function onGameLoaded(data:*):void
		{
			if(data == null)
			{
				onGameLoadError(1);
				return;
			}
			
			var initLoader:Loader = new Loader();
			initLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onInitializerLoaded);
			initLoader.loadBytes(data);
		}
		
		private function onInitializerLoaded(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onInitializerLoaded);
			
			var loader:Loader = loaderInfo.loader;
			var gameInitializer:DisplayObject = loader.content;
			stage.addChild(gameInitializer);
			onResize();
		}
		
		private function disposeGameLoader():void
		{
			AppCenter.instance.loader.clearResLoaded("Initializer.swf?" + currentVersion);
		}
		
		private function getLoginBtnFrame(btnColorA:uint, btnColorB:uint, textColor:uint):Sprite
		{
			var btnFrame:Sprite = new Sprite();
			btnFrame.graphics.beginFill(btnColorA);
			btnFrame.graphics.drawRect(0,0,100,25);
			btnFrame.graphics.beginFill(btnColorB);
			btnFrame.graphics.drawRect(0,0,98,23);
			btnFrame.graphics.endFill();
			
			var label:TextField = new TextField();
			label.text = "登录|Login";
			label.textColor = textColor;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = 20;
			label.y = 2;
			btnFrame.addChild(label);
			return btnFrame;
		}
		
		private function get sharedObject():SharedObject
		{
			return  SharedObject.getLocal("name");
		}
		//------------------------------ virtual login panel ----------
		private var _loginName:TextField;
		
		private var _loginPSW:TextField;
		
		private var _loginBtn:SimpleButton;
		
		private var _checkBox:Sprite;
		private function initDebugLogin():void
		{
			var loginPanel:Sprite = new Sprite();
			
			var tf:TextFormat = new TextFormat();
			tf.size = 16;
			tf.color = 0;
			_loginName = new TextField();
			_loginName.wordWrap = false;
			_loginName.multiline = false;
			_loginName.background = true;
			_loginName.border = true;
			_loginName.width = 150;
			_loginName.height = 25;
			_loginName.type = TextFieldType.INPUT;
			_loginName.textColor = 0;
			_loginName.selectable = true;
			_loginName.defaultTextFormat = tf;
			_loginName.text = "text";
			
			var nameLabel:TextField = new TextField();
			nameLabel.text = "用户名|Username:";
			nameLabel.textColor = 0xaaaaaa;
			nameLabel.selectable = false;
			nameLabel.mouseEnabled = false;
			////////////////////////////////////////////
			var loginData:Object = new Object()// sharedObjectServ.getLoginData();
			
			if(loginData.hasOwnProperty("name"))
			{
				_loginName.text = loginData.name; 
			}
			//////////////////////////////////////////////
			
			_loginPSW = new TextField();
			_loginPSW.background = true;
			_loginPSW.border = true;
			_loginPSW.width = 150;
			_loginPSW.height = 25;
			_loginPSW.type = TextFieldType.INPUT;
			_loginPSW.textColor = 0;
			_loginPSW.selectable = true;
			_loginPSW.defaultTextFormat = tf;
			_loginPSW.displayAsPassword = true;
			
			var pswLabel:TextField = new TextField();
			pswLabel.text = "密码(选填)|Password(Option):";
			pswLabel.textColor = 0xaaaaaa;
			pswLabel.width = 160;
			pswLabel.selectable = false;
			pswLabel.mouseEnabled = false;
			
			///////////////////////////////////////////////////
			_loginBtn = new SimpleButton();
			_loginBtn.upState = getLoginBtnFrame(0xaaaaaa, 0xcccccc, 0x333333);
			_loginBtn.overState = _loginBtn.hitTestState = _loginBtn.downState = getLoginBtnFrame(0x666666, 0x999999, 0xeeeeee);
			
			///////////////////////////////////////////////
			
			
			_checkBox = new Sprite();
			_checkBox.buttonMode = true;
			_checkBox.useHandCursor = true;
			_checkBox.addEventListener(MouseEvent.CLICK, onSelected);
			var protectedLabel:TextField = new TextField();
			protectedLabel.autoSize = TextFieldAutoSize.LEFT;
			protectedLabel.text = "是否启用防沉迷";
			protectedLabel.textColor = 0xaaaaaa;
			if(!Boolean(loginData.fcm))
			{
				onSelected();
			}
			else
			{
				updateCheckBox();
			}
			///////////////////////////////////////////////
			
			nameLabel.y = _loginName.y-20;
			
			_loginPSW.y = _loginName.y+50;
			pswLabel.y = _loginPSW.y-20;
			
			_checkBox.y = _loginPSW.y + 50;
			protectedLabel.x = 20;
			protectedLabel.y = _checkBox.y-2;
			
			_loginBtn.y = _checkBox.y + 30;
			
			loginPanel.addChild(_loginBtn);
			loginPanel.addChild(_loginName);
			loginPanel.addChild(nameLabel);
			loginPanel.addChild(_loginPSW);
			loginPanel.addChild(pswLabel);
			loginPanel.addChild(_checkBox);
			loginPanel.addChild(protectedLabel);
			
			loginPanel.x = (1248-loginPanel.width)*0.5;
			loginPanel.y = (648-loginPanel.height)*0.5;
			addChild(loginPanel);
			
			_loginBtn.addEventListener(MouseEvent.CLICK, onLoginHandle);
		}
		
		private function onUnCaughtErrorEventHandle(event:UncaughtErrorEvent):void
		{
			AppCenter.instance.log.error("[ERROR] Perloader catch uncaught error:", event.toString());
		}
		private function onSelected(event:MouseEvent = null):void
		{
			_protectedSelected = !_protectedSelected;
			updateCheckBox();
		}
		
		private function updateCheckBox():void
		{
			_checkBox.graphics.clear();
			_checkBox.graphics.beginFill(0xffffff);
			_checkBox.graphics.drawRect(0,0,16,16);
			
			if(_protectedSelected == true)
			{
				_checkBox.graphics.beginFill(0x333333);
				_checkBox.graphics.drawRect(4,4,8,8);
			}
			
			_checkBox.graphics.endFill();
		}
		private function onLoginHandle(event:MouseEvent):void
		{
			if(_loginName.text == "")
			{
				return;
			}
			_name = _loginName.text;
			_psw = _loginPSW.text;
			_needFcm = !_protectedSelected;
			
			//	sharedObjectServ.setLoginData(_name,_psw,_needFcm);
			initLoadingBar();
		}		
	}
}