package view
{
	import flash.display.MovieClip;
	
	import phantom.components.Button;
	import phantom.components.list.List;
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
			confirm.clickHandler = new Handler(onClickBtn);
			addAdapter(confirm);
			
			var list:List = new List(getMcPath("list"),myRender,6);
			list.data = new DataProvider([3,1,2,3,4,5,1,2,3,4,5,6,7,8,8,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,100,2,2,2,2,2,2,2,2,2,2,2,2,1,3,3,3,3,3,3,1,3,3,4,1,4,3,3,3,45,1,9]);
			list.clickHandler = new Handler(onClick);
		}
		
		private function onClickBtn():void
		{
			trace("btn.click");			
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
import phantom.components.Label;
import phantom.components.list.data.DefaultItemRenderer;

class myRender extends DefaultItemRenderer
{
	public function myRender(skin:*)
	{
		super(skin);
	}
	private var _txt:Label;
	override protected function initializeSkin(skin:*):void
	{
		super.initializeSkin(skin);
		_txt = new Label(getTextField("txt"));	
	}
	
	override protected function refreshData():void
	{
		if(data)
		{
			_txt.text = data + "";
			visible = true;
		}
		else
		{
			visible = false;
		}
	}
}