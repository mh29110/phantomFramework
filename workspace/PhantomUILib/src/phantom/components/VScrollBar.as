package phantom.components
{
	public class VScrollBar extends ScrollBar
	{
		public function VScrollBar(skin:*)
		{
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void
		{
			super.initializeSkin(skin);
			_slider.direction = VERTICAL;
		}
	}
}