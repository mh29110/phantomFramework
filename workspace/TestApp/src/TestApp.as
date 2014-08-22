package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	import phantom.core.handlers.Handler;
	
	/**
	 * @author liphantomjia@gmail.com
	 * 
	 */
	public class TestApp extends Sprite
	{
		public function TestApp()
		{
			AppCenter.instance.init(this);
			AppCenter.instance.loader.loadSWF("assets/majorscreen.swf",new Handler(onComplete));
			AppCenter.instance.loader.loadBMD("assets/001.png",new Handler(onBMPComplete));
		}
		
		private function onBMPComplete(content:*):void
		{
			addChild(new Bitmap(content));
		}
		private function onComplete(content:*):void  
		{
			var majorScreenClass:Class = getDefinitionByName("screen.view.hy_ui_scr_majorscreen") as Class;
			var majorScreen:MovieClip = new majorScreenClass();
			addChild(majorScreen);
//			App.log.info("hello");
//			App.log.toggle();
		}
	}
}