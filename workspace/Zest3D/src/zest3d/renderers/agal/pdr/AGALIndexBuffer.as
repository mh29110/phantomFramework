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
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import io.plugin.core.interfaces.IDisposable;
	import zest3d.renderers.agal.AGALRenderer;
	import zest3d.renderers.interfaces.IIndexBuffer;
	import zest3d.renderers.Renderer;
	import zest3d.resources.enum.BufferLockingType;
	import zest3d.resources.IndexBuffer;
	
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class AGALIndexBuffer implements IIndexBuffer, IDisposable 
	{
		
		private var _renderer: AGALRenderer;
		private var _context: Context3D;
		private var _indexBuffer: IndexBuffer;
		
		private var _indexBuffer3D: IndexBuffer3D;
		
		
		public function AGALIndexBuffer( renderer: Renderer, iBuffer: IndexBuffer ) 
		{
			_renderer = renderer as AGALRenderer;
			_context = _renderer.data.context;
			
			_indexBuffer = iBuffer;
			
			_indexBuffer3D = _context.createIndexBuffer( _indexBuffer.numElements );
			
			_indexBuffer3D.uploadFromByteArray( _indexBuffer.data, 0, 0, _indexBuffer.numElements );
		}
		
		public function dispose(): void
		{
			_indexBuffer3D.dispose();
		}
		
		public function enable( renderer: Renderer ): void
		{
		}
		
		public function disable( renderer: Renderer ): void
		{
		}
		
		public function lock( mode: BufferLockingType ): void
		{
		}
		
		public function unlock(): void
		{
		}
		
		[Inline]
		public final function get indexBuffer3D():IndexBuffer3D 
		{
			return _indexBuffer3D;
		}
		
	}

}