package phantom.components
{
	public class HScrollBar extends ScrollBar
	{
		public function HScrollBar(skin:*)
		{
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void
		{
			super.initializeSkin(skin);
			_slider.direction = HORIZONTAL;
		}
	}
}