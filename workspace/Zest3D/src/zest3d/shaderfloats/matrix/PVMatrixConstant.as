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
package zest3d.shaderfloats.matrix 
{
	import io.plugin.core.interfaces.IDisposable;
	import io.plugin.math.algebra.HMatrix;
	import zest3d.scenegraph.Camera;
	import zest3d.scenegraph.Visual;
	import zest3d.shaderfloats.ShaderFloat;
	
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class PVMatrixConstant extends ShaderFloat implements IDisposable 
	{
		
		public function PVMatrixConstant() 
		{
			super( 4 );
			_allowUpdater = true;
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
		
		override public function update(visual:Visual, camera:Camera):void 
		{
			var projViewMatrix: HMatrix = camera.projectionViewMatrix;
			var tuple: Array = projViewMatrix.toTuple();
			
			_data.position = 0;
			for ( var i: int = 0; i < 16; ++i )
			{
				_data.writeFloat( tuple[ i ] );
			}
		}
		
	}

}