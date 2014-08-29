package view
{
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import phantom.components.Button;
	import phantom.components.HSlider;
	import phantom.components.ScrollBar;
	import phantom.components.Slider;
	import phantom.components.VScrollBar;
	import phantom.components.list.FixedList;
	import phantom.components.list.data.DataProvider;
	import phantom.core.handlers.Handler;
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
			
			var list:FixedList = new FixedList(getMcPath("list.mc_list"));
			list.data = new DataProvider([3,1,2,3,4,5,1,2,3,4,5,6,7,8,8,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,,2,2,2,2,2,2,2,2,2,2,2,2,1,3,3,3,3,3,3,1,3,3,4,,4,3,3,3,45]);
			list.clickHandler = new Handler(onClick);
			
			var scroll:ScrollBar = new VScrollBar(getMcPath("list.mc_scroll"));
			scroll.setScroll(0,100,0);
			scroll.target = list.view  as Sprite;
			scroll.changeHandler = new Handler(onChangeSlider);
		}
		
		private function onChangeSlider(value:*):void
		{
			trace(value);
		}
		private function onClick(data:*,v:*):void
		{
			trace("d.onClick()",data,v);
		}
	}
}