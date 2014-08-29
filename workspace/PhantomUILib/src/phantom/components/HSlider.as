package phantom.components
{
	/**
	 * 水平滑动条 
	 * @author liphantomjia@gmail.com
	 * 
	 */
	public class HSlider extends Slider
	{
		public function HSlider(skin:*)
		{
			super(skin);
		}
		
		override public function initialize(skin:*):void
		{
			super.initialize(skin);
			direction = HORIZONTAL;
		}
	}
}