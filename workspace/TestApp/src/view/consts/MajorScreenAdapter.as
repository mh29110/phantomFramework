package view.consts
{
	import flash.display.MovieClip;
	
	import phantom.ui.components.Button;
	import phantom.ui.components.skinAdapter;
	import phantom.ui.screen.ScreenAdapter;
	
	public class MajorScreenAdapter extends ScreenAdapter
	{

		private var confirm:skinAdapter;
		public function MajorScreenAdapter(skin:MovieClip=null)
		{
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void
		{
			super.initializeSkin(skin);
			confirm = new Button(getMcPath("btn_confirm"));
			addAdapter(confirm);
		}
	}
}