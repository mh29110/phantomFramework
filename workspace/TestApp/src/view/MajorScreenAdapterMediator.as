package view
{
	import org.puremvc.as3.interfaces.INotification;
	
	import phantom.ui.screen.ScreenAdapterMediator;
	
	public class MajorScreenAdapterMediator extends ScreenAdapterMediator
	{
		public function MajorScreenAdapterMediator(name:String, controller:*=null)
		{
			super(name, controller);
		}
		
		override protected function initialize():void
		{
			super.initialize();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests();
		}
		
		
	}
}