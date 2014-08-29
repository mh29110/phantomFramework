package view
{
	import flash.display.MovieClip;
	
	import phantom.components.Button;
	import phantom.components.list.FixedList;
	import phantom.core.handlers.Handler;
	import phantom.components.list.data.DataProvider;
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
			list.data = new DataProvider([0,1,2,3,4,5]);
			list.clickHandler = new Handler(onClick);
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