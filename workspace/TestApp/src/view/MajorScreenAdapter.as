package view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import phantom.core.handlers.Handler;
	import phantom.components.Button;
	import phantom.components.ScrollBar;
	import phantom.ui.screen.ScreenAdapter;
	
	public class MajorScreenAdapter extends ScreenAdapter
	{

		private var confirm:Button;

		private var scroll:ScrollBar;
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
			
			scroll = new ScrollBar(getMcPath("mc_scroll"));
			scroll.setScroll(0,100,0);
			scroll.target = confirm.view as Sprite;
			scroll.changeHandler = new Handler(onChangeSlider);
		}
		
		private function onChangeSlider(value:*):void
		{
			trace(value);
		}
		private function onClick():void
		{
			trace("d.onClick()",confirm.selected);
		}
	}
}