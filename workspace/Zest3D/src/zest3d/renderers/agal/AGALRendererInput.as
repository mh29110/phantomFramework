/**
 * Plugin.IO - http://www.plugin.io
 * Copyright (c) 2013
 *
 * Geometric Tools, LLC
 * Copyright (c) 1998-2012
 * 
 * Distributed under the Boost Software License, Version 1.0.
 * http://www.boost.org/LICENSE_1_0.txt
 */
package zest3d.renderers.agal 
{
	import flash.display3D.Context3D;
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class AGALRendererInput 
	{
		
		protected var _context:Context3D;
		
		public function AGALRendererInput( context:Context3D ) 
		{
			_context = context;
		}
		
		public function get context(): Context3D
		{
			return _context;
		}
		
	}

}