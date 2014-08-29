package phantom.components
{
	/**
	 * 垂直滑动条
	 * @author liphantomjia@gmail.com
	 * 
	 */
	public class VSlider extends Slider
	{
		public function VSlider(skin:*)
		{
			super(skin);
		}
		
		override public function initialize(skin:*):void
		{
			super.initialize(skin);
			direction = VERTICAL;
		}
	}
}