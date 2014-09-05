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
package zest3d.renderers.interfaces 
{
	import zest3d.renderers.Renderer;
	import zest3d.resources.Texture2D;
	
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public interface IRenderTarget 
	{
		function enable( renderer: Renderer ): void;
		function disable( renderer: Renderer ): void;
		function readColor( i: int, renderer: Renderer, texture: Texture2D ): void;
	}
	
}