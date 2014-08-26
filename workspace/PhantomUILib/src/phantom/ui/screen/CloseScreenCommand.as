package phantom.ui.screen
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CloseScreenCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var params:Object = notification.getBody();
			var screenMediator:ScreenAdapterMediator;
			screenMediator = facade.retrieveMediator(params as String) as ScreenAdapterMediator;
			
			facade.removeMediator(screenMediator.getMediatorName());
			screenMediator.dispose();
		}
	}
}