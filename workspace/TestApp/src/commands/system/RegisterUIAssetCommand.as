package commands.system
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import phantom.core.consts.ManagerName;
	import phantom.ui.flash.UIAssetLinker;
	
	import view.MajorScreenAdapter;
	import view.MajorScreenAdapterMediator;
	import view.consts.ScreenUIDefine;
	
	public class RegisterUIAssetCommand extends SimpleCommand
	{
		public function RegisterUIAssetCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var uiLinker:UIAssetLinker = AppCenter.instance.getManager(ManagerName.UIASSET_LINKER) as UIAssetLinker;
			
			uiLinker.addUI(ScreenUIDefine.MajorScreen,MajorScreenAdapter,MajorScreenAdapterMediator);
		}
	}
}