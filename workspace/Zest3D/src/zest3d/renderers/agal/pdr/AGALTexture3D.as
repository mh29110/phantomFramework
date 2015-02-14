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
package zest3d.renderers.agal.pdr 
{
	import io.plugin.core.interfaces.IDisposable;
	import zest3d.renderers.interfaces.ITexture3D;
	import zest3d.renderers.Renderer;
	import zest3d.resources.enum.BufferLockingType;
	import zest3d.resources.Texture3D;
	
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class AGALTexture3D implements ITexture3D, IDisposable 
	{
		
		public function AGALTexture3D( renderer: Renderer, texture: Texture3D ) 
		{
			
		}
		
		public function dispose(): void
		{
			
		}
		
		public function enable( renderer: Renderer, textureUnit: int ): void
		{
			trace( "* enabling texture 3d." );
		}
		
		public function disable( renderer: Renderer, textureUnit: int ): void
		{
			trace( "* disabling texture 3d." );
		}
		
		public function lock( level: int, mode: BufferLockingType ): void
		{
			trace( "* locking texture 3d." );
		}
		
		public function unlock( level: int ): void
		{
			trace( "* unlocking texture 3d." );
		}
		
	}

}