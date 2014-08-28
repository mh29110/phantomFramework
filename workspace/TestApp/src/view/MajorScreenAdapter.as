package view
{
	import flash.display.MovieClip;
	
	import phantom.core.handlers.Handler;
	import phantom.ui.components.Button;
	import phantom.ui.screen.ScreenAdapter;
	
	public class MajorScreenAdapter extends ScreenAdapter
	{

		private var confirm:Button;
		public function MajorScreenAdapter(skin:MovieClip=null)
		{
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void
		{
			super.initializeSkin(skin);
			confirm = new Button(getMcPath("btn_confirm"));
			confirm.clickHandler = new Handler(onClick);
			addAdapter(confirm);
		}
		private function onClick():void
		{
			trace("d.onClick()",confirm.selected);
		}
	}
}