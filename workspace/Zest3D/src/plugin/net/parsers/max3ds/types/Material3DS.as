package plugin.net.parsers.max3ds.types 
{
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class Material3DS 
	{
		
		public var name: String = "";
		public var mapName: String = "";
		public var diffuse: Color3DS = new Color3DS();
		public var ambient: Color3DS = new Color3DS();
		public var specular: Color3DS = new Color3DS();
		public var shininess: Number = 0;
		public var transparency: Number = 1;
		
		public function Material3DS() 
		{
		}
		
	}

}