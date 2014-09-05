package plugin.net.parsers.max3ds.types 
{
	import flash.utils.ByteArray;
	import plugin.net.parsers.max3ds.errors.Parser3DSError;
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class Scene3DS 
	{
		
		public static const DECODE_ALL: int = 3;
		public static const DECODE_USED_PARAMS: int = 2;
		public static const DECODE_USED_PARAMS_AND_CHUNKS: int = 1;
		
		private var _meshList: Vector.<Mesh3DS> = new Vector.<Mesh3DS>();
		private var _cameraList: Vector.<Camera3DS> = new Vector.<Camera3DS>();
		private var _materialList: Vector.<Material3DS> = new Vector.<Material3DS>();
		private var _lightList: Vector.<Light3DS> = new Vector.<Light3DS>();
		private var _startFrame: int = 0;
		private var _endFrame: int = 0;
		
		private var _fileData: ByteArray;
		private var _decode: Decode3DS;
		
		//private var _filePos: int = 0;
		//private var _fileLength: int = 0;
		
		public function get meshList(): Vector.<Mesh3DS>
		{
			return _meshList;
		}
		
		public function get cameraList(): Vector.<Camera3DS>
		{
			return _cameraList;
		}
		
		public function get materialList(): Vector.<Material3DS>
		{
			return _materialList;
		}
		
		public function get lightList(): Vector.<Light3DS>
		{
			return _lightList;
		}
		
		public function get startFrame(): int
		{
			return _startFrame;
		}
		
		public function get endFrame(): int
		{
			return _endFrame;
		}
		
		public function Scene3DS( data: ByteArray ) 
		{
			_fileData = data;
			_fileData.position = 0;
			
			try {
				read3DS();
			}
			catch ( e: Parser3DSError )
			{
				throw new Parser3DSError( "3DS-parser: " + e.message )
			}
			finally
			{
				_fileData = null;
				_decode = null;
			}
		}
		
		public function addMesh( m: Mesh3DS ): void
		{
			_meshList.push( m );
		}
		
		public function addCamera( c: Camera3DS ): void
		{
			_cameraList.push( c );
		}
		
		public function addMaterial( m: Material3DS ): void
		{
			_materialList.push( m );
		}
		
		public function addLight( l: Light3DS ): void
		{
			_lightList.push( l );
		}
		
		public function get numMeshes(): int
		{
			return _meshList.length;
		}
		
		public function getMeshAt( index: int ): Mesh3DS
		{
			return _meshList[ index ];
		}
		
		public function get numCameras(): int
		{
			return _cameraList.length;
		}
		
		public function getCameraAt( index: int ): Camera3DS
		{
			return _cameraList[ index ];
		}
		
		public function get numMaterials(): int
		{
			return _materialList.length;
		}
		
		public function getMaterialAt( index: int ): Material3DS
		{
			return _materialList[ index ];
		}
		
		public function get numLights(): int
		{
			return _lightList.length;
		}
		
		public function getLightAt( index: int ): Light3DS
		{
			return _lightList[ index ];
		}
		
		
		
		
		/*
		public function readByte(): int
		{
			if ( _filePos >= _fileLength )
			{
				throw new Parser3DSError( "Read out of bounds! File is probably corrupt." );
			}
			_fileData.position = _filePos;
			_filePos++;
			return _fileData.readByte();
		}
		
		public function readUnsignedShort(): int
		{
			if ( _filePos + 2 > _fileLength )
			{
				throw new Parser3DSError( "Read out of bounds! File is probably corrupt." );
			}
			_fileData.position = _filePos;
			var val: int = 
		}
		*/
		
		
		private function skipBytes( n: int ): int
		{
			if ( n < 0)
			{
				throw new Parser3DSError( "Negative chunk size! File is probably corrupt." );
			}
			else if ( _fileData.position + n > _fileData.length )
			{
				throw new Parser3DSError( "Read out of bounds! File is probably corrupt." );
			}
			_fileData.position += n;
			return n;
		}
		
		private function skipChunk( chunkLength: int ): void
		{
			if ( _decode )
			{
				_decode.enter();
			}
			skipBytes( chunkLength );
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		private function read_HEAD(): Head
		{
			var id: int = _fileData.readUnsignedShort();
			var length: int = _fileData.readInt();
			
			if ( _decode )
			{
				_decode.printHead( id, length );
			}
			
			return new Head( id, length );
		}
		
		private function read_NAME( length: int = 32 ): String
		{
			var str: String = "";
			var terminated: Boolean = false;
			var n: int = 0;
			
			var ch: int;
			
			for ( var i: int = 0; i < length; ++i )
			{
				ch = _fileData.readByte();
				if ( ch == 0 )
				{
					terminated = true;
					break;
				}
				else
				{
					str += String.fromCharCode( ch );
				}
			}
			
			if ( terminated == false )
			{
				throw new Parser3DSError( "Name not terminated! File is probably corrupt." );
			}
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Name: " + str + "." );
				_decode.exit();
			}
			
			return str;
		}
		
		private function read3DS(): void
		{
			var head: Head = read_HEAD();
			
			if ( head.id != CHUNK_M3DMAGIC )
			{
				throw new Parser3DSError( "Bad signature! This is not a 3D Studio R4 .3ds file." );
			}
			
			read_M3DMAGIC( head.length - 6 );
		}
		
		
		private function read_M3DMAGIC( chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_MDATA:
							read_MDATA( head.length - 6 );
						break;
					case CHUNK_KFDATA:
							read_KFDATA( head.length - 6 );
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
			
		}
		
		private function read_MDATA( chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_NAMED_OBJECT:
							read_NAMED_OBJECT( head.length - 6 );
						break;
					case CHUNK_MAT_ENTRY:
							read_MAT_ENTRY( head.length - 6 );
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		private function readColor( chunkLength: int ): Color3DS
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			var lvColor: Color3DS = new Color3DS();
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				
				switch( head.id )
				{
					case CHUNK_COL_RGB:
							lvColor = readRGBColor();
						break;
					case CHUNK_COL_TRU:
							lvColor = readTrueColor();
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
			
			return lvColor;
		}
		
		
		
		private function readPercentage( chunkLength: int ): Number
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			var val: Number = 0;
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch(  head.id )
				{
					case CHUNK_PERCENTW:
							var trans: int = _fileData.readUnsignedShort();
							val = ( trans / 100 );
						break;
					case CHUNK_PERCENTF:
							val = _fileData.readFloat()
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
			
			return val;
		}
		
		private function read_MAT_ENTRY( chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			var mat: Material3DS = new Material3DS();
			addMaterial( mat );
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_MAT_NAME:
							mat.name = read_NAME();
						break;
					case CHUNK_MAT_AMBIENT:
							mat.ambient = readColor( head.length - 6 );
						break;
					case CHUNK_MAT_SPECULAR:
							mat.specular = readColor( head.length - 6 );
						break;
					case CHUNK_MAT_DIFFUSE:
							mat.diffuse = readColor( head.length - 6 );
						break;
					case CHUNK_MAT_MAPNAME:
							mat.mapName = read_NAME();
						break;
					case CHUNK_MAT_MAP:
							read_MAT_ENTRY( head.length - 6 );
						break;
					//case CHUNK_MAT_SHININESS:
							//mat._shininess = readFloat();
						//break;
					case CHUNK_MAT_TRANSPARENCY:
							mat.transparency = readPercentage( head.length - 6 );
							mat.transparency = 1 - mat.transparency;
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
				
				if ( _decode )
				{
					_decode.exit();
				}
			}
			
		}
		
		private function read_NAMED_OBJECT( chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			var name: String = read_NAME();
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_N_TRI_OBJECT:
							read_N_TRI_OBJECT( name, head.length - 6 );
						break;
					case CHUNK_N_LIGHT:
							read_N_LIGHT( name, head.length - 6 );
						break;
					case CHUNK_N_CAMERA:
							read_N_CAMERA( name, head.length - 6 );
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		private function readSpotChunk( pLight: Light3DS, chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			pLight.target.x = _fileData.readFloat();
			pLight.target.y = _fileData.readFloat();
			pLight.target.z = _fileData.readFloat();
			
			pLight.hotspot = _fileData.readFloat();
			pLight.falloff = _fileData.readFloat();
			
			if ( _decode )
			{
				_decode.println( "Target: " + pLight.target );
				_decode.println( "Hotspot: " + pLight.hotspot );
				_decode.println( "Falloff: " + pLight.falloff );
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_LIT_RAYSHAD:
						// (readUnsignedShort() > 0);
							pLight.rayShadows = true;
						break;
					case CHUNK_LIT_SHADOWED:
						// (readUnsignedShort() > 0);
							pLight.shadowed = true;
						break;
					case CHUNK_LIT_LOCAL_SHADOW:
							_fileData.readFloat();
							_fileData.readFloat();
							_fileData.readFloat();
						break;
					case CHUNK_LIT_LOCAL_SHADOW2:
							pLight.shadowBias = _fileData.readFloat();
							pLight.shadowFilter = _fileData.readFloat();
							pLight.shadowSize = _fileData.readFloat();
						break;
					case CHUNK_LIT_SEE_CONE:
						// (readUnsignedShort() > 0);
							pLight.cone = true;
						break;
					case CHUNK_LIT_SPOT_RECTANGULAR:
						// (readUnsignedShort() > 0);
							pLight.rectangular = true;
						break;
					case CHUNK_LIT_SPOT_OVERSHOOT:
						// (readUnsignedShort() > 0);
						pLight.overshoot = true;
						break;
					case CHUNK_LIT_SPOT_PROJECTOR:
						// (readUnsignedShort() > 0);
							pLight.projector = true;
							pLight.name = read_NAME( 64 );
						break;
					case CHUNK_LIT_SPOT_RANGE:
							_fileData.readFloat();
						break;
					case CHUNK_LIT_SPOT_ROLL:
							pLight.aspect = _fileData.readFloat();
						break;
					case CHUNK_LIT_SPOT_ASPECT:
							pLight.rayBias = _fileData.readFloat();
						break;
					case CHUNK_LIT_RAY_BIAS:
							pLight.rayBias = _fileData.readFloat();
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		private function read_N_LIGHT( name: String, chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			var lit: Light3DS = new Light3DS();
			lit.name = name;
			
			addLight( lit );
			
			lit.position.x = _fileData.readFloat();
			lit.position.y = _fileData.readFloat();
			lit.position.z = _fileData.readFloat();
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Position: " + lit.position );
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_LIT_OFF:
							lit.off = ( _fileData.readUnsignedShort() > 0 );
						break;
					case CHUNK_LIT_SPOT:
							readSpotChunk( lit, head.length - 6 );
						break;
					case CHUNK_COL_RGB:
					case CHUNK_COL_LINRGB:
							lit.color = readRGBColor();
						break;
					case CHUNK_COL_TRU:
					case CHUNK_COL_LINTRU:
							lit.color = readTrueColor();
						break;
					case CHUNK_LIT_ATTENUATE:
							lit.attenuation = _fileData.readFloat();
						break;
					case CHUNK_LIT_INNER_RANGE:
							lit.innerRange = _fileData.readFloat();
						break;
					case CHUNK_LIT_OUTER_RANGE:
							lit.outerRange = _fileData.readFloat();
						break;
					case CHUNK_LIT_MULTIPLIER:
							lit.multiplexer = _fileData.readFloat();
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		
		private function readRGBColor(): Color3DS
		{
			var lvColor: Color3DS = new Color3DS();
			lvColor.red = _fileData.readFloat();
			lvColor.green = _fileData.readFloat();
			lvColor.blue = _fileData.readFloat();
			
			return lvColor;
		}
		
		private function readTrueColor(): Color3DS
		{
			var lvColor: Color3DS = new Color3DS();
			lvColor.red = (_fileData.readByte() & 0xFF) / 255;
			lvColor.green = (_fileData.readByte() & 0xFF) / 255;
			lvColor.blue = (_fileData.readByte() & 0xFF) / 255;
			
			return lvColor;
		}
		
		
		private function read_N_CAMERA( name: String, chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			var cam: Camera3DS = new Camera3DS();
			cam.name = name;
			
			addCamera( cam );
			
			cam.position.x = _fileData.readFloat();
			cam.position.y = _fileData.readFloat();
			cam.position.z = _fileData.readFloat();
			
			cam.target.x = _fileData.readFloat();
			cam.target.y = _fileData.readFloat();
			cam.target.z = _fileData.readFloat();
			
			cam.roll = _fileData.readFloat();
			cam.lens = _fileData.readFloat();
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Position: " + cam.position );
				_decode.println( "Target:   " + cam.target );
				_decode.println( "Roll: " + cam.roll );
				_decode.println( "Lens: " + cam.lens );
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_CAM_RANGES:
							read_CAM_RANGES( cam );
						break;
					case CHUNK_CAM_SEE_CONE:
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		
		private function read_CAM_RANGES( cam: Camera3DS ): void
		{
			cam.nearPlane = _fileData.readFloat();
			cam.farPlane = _fileData.readFloat();
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Near plane:" + cam.nearPlane );
				_decode.println( "Far plane: " + cam.farPlane );
				_decode.exit();
			}
		}
		
		
		private function read_N_TRI_OBJECT( name: String, chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			var mes: Mesh3DS = new Mesh3DS();
			mes.name = name;
			
			addMesh( mes );
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_POINT_ARRAY:
							mes.vertices = read_POINT_ARRAY();
						break;
					case CHUNK_TEX_VERTS:
							mes.texCoords = read_TEX_VERTS();
						break;
					case CHUNK_MESH_TEXTURE_INFO:
							read_MESH_TEXTURE_INFO( mes );
						break;
					case CHUNK_MESH_MATRIX:
							readMatrix( mes.localSystem );
						break;
					case CHUNK_FACE_ARRAY:
							read_FACE_ARRAY( mes, head.length - 6 );
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
			
		}
		
		
		private function read_POINT_ARRAY(): Vector.<Vertex3DS>
		{
			var verts: int = _fileData.readUnsignedShort();
			var v: Vector.<Vertex3DS> = new Vector.<Vertex3DS>( verts );
			
			var n: int = 0;
			var x: Number = 0;
			var y: Number = 0;
			var z: Number = 0;
			for ( n = 0; n < verts; ++n )
			{
				x = _fileData.readFloat();
				y = _fileData.readFloat();
				z = _fileData.readFloat();
				v[ n ] = new Vertex3DS( x, y, z );
			}
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Vertices: " + verts );
				_decode.exit();
			}
			
			return v;
		}
		
		private function read_TEX_VERTS(): Vector.<TexCoords3DS>
		{
			var coords: int = _fileData.readUnsignedShort();
			var tc: Vector.<TexCoords3DS> = new Vector.<TexCoords3DS>( coords );
			
			var n: int = 0;
			var u: Number = 0;
			var v: Number = 0;
			
			for ( n = 0; n < coords; ++n )
			{
				u = _fileData.readFloat();
				v = _fileData.readFloat();
				if ( u < -100 || u > 100 )
				{
					u = 0;
				}
				if ( v < -100 || v > 100 )
				{
					v = 0;
				}
				tc[ n ] = new TexCoords3DS( u, v );
			}
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Coords: " + coords );
				_decode.exit();
			}
			
			return tc;
		}
		
		
		private function read_MESH_TEXTURE_INFO( mes: Mesh3DS ): void
		{
			mes.texMapType = _fileData.readUnsignedShort();
			mes.texUTile = _fileData.readFloat();
			mes.texVTile = _fileData.readFloat();
			
			if ( _decode )
			{
				_decode.enter();
				var type: String = "";
				switch( mes.texMapType )
				{
					case Mesh3DS.PLANAR_MAP:
							type = "PLANAR";
						break;
					case Mesh3DS.CYLINDRICAL_MAP:
							type = "CYLINDRICAL";
						break;
					case Mesh3DS.SPHERICAL_MAP:
							type = "SPHERICAL";
						break;
					default:
							type = "" + mes.texMapType;
						break;
				}
				
				_decode.println( "Texture mapping type: " + type );
				_decode.println( "Texture U tiling: " + mes.texUTile );
				_decode.println( "Texture V tiling: " + mes.texVTile );
				
			}
			
			skipBytes( 4 * 4 + ( 3 * 4 + 3 ) * 4 );
			
			if ( _decode )
			{
				_decode.exit();
			}
			
		}
		
		
		private function readMatrix( matrix: Array ): void
		{
			matrix[ 0 ][ 0 ] = _fileData.readFloat();
			matrix[ 0 ][ 2 ] = _fileData.readFloat();
			matrix[ 0 ][ 1 ] = _fileData.readFloat();
			
			matrix[ 2 ][ 0 ] = _fileData.readFloat();
			matrix[ 2 ][ 2 ] = _fileData.readFloat();
			matrix[ 2 ][ 1 ] = _fileData.readFloat();
			
			matrix[ 1 ][ 0 ] = _fileData.readFloat();
			matrix[ 1 ][ 2 ] = _fileData.readFloat();
			matrix[ 1 ][ 1 ] = _fileData.readFloat();
			
			matrix[ 0 ][ 3 ] = _fileData.readFloat();
			matrix[ 2 ][ 3 ] = _fileData.readFloat();
			matrix[ 3 ][ 3 ] = _fileData.readFloat();
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Matrix: " + matrix );
				_decode.exit();
			}
			
		}
		
		
		private function read_FACE_ARRAY( mes: Mesh3DS, chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			var faces: int = _fileData.readUnsignedShort();
			mes.faces = new Vector.<Face3DS>( faces );
			
			var n: int = 0;
			var p0: int = 0;
			var p1: int = 0;
			var p2: int = 0;
			var flags: int = 0;
			
			for ( n = 0; n < faces; ++n )
			{
				p0 = _fileData.readUnsignedShort();
				p1 = _fileData.readUnsignedShort();
				p2 = _fileData.readUnsignedShort();
				flags = _fileData.readUnsignedShort();
				mes.faces[ n ] = new Face3DS( p0, p1, p2, flags );
			}
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Faces: " + faces );
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_MSH_MAT_GROUP:
							read_MSH_MAT_GROUP( mes );
						break;
					case CHUNK_SMOOTH_GROUP:
							read_SMOOTH_GROUP( mes, head.length - 6 );
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		private function read_MSH_MAT_GROUP( mes: Mesh3DS ): void
		{
			var name: String = read_NAME();
			
			var fm: FaceMaterial3DS = new FaceMaterial3DS();
			mes.addFaceMaterial( fm );
			
			var i: int = 0;
			
			for ( i = 0; i < _materialList.length; ++i )
			{
				if ( _materialList[ i ].name == name )
				{
					fm.matIndex = i;
					break;
				}
			}
			
			var indexes: int = _fileData.readUnsignedShort();
			fm.faceIndices = new Vector.<int>( indexes );
			
			for ( i = 0; i < indexes; ++i )
			{
				fm.faceIndices[ i ] = _fileData.readUnsignedShort();
			}
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Faces: " + indexes );
				_decode.exit();
			}
			
		}
		
		
		private function read_SMOOTH_GROUP( mes:  Mesh3DS, chunkLength: int ): void
		{
			var entries: int = chunkLength / 4;
			mes.smoothGroup = new Vector.<int>( entries );
			
			var n: int = 0;
			for ( n = 0; n < entries; ++n )
			{
				mes.smoothGroup[ n ] = _fileData.readInt();
			}
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Entries: " + entries );
				_decode.exit();
			}
			
			if ( entries != mes.numFaces )
			{
				throw new Parser3DSError( "SMOOTH_GROUP entries != faces. File is probably corrupt!" );
			}
			
		}
		
		private function read_KFDATA( chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_KFSEG:
							_startFrame = _fileData.readInt();
							_endFrame = _fileData.readInt();
							if ( _decode )
							{
								_decode.enter();
								_decode.println( "Start frame: " + _startFrame );
								_decode.println( "End frame: " + _endFrame );
								_decode.exit();
							}
						break;
					case CHUNK_OBJECT_NODE_TAG:
							read_OBJECT_NODE_TAG( head.length - 6 );
						break;
					case CHUNK_TARGET_NODE_TAG:
							read_TARGET_NODE_TAG(head.length - 6);
						break;
					case CHUNK_CAMERA_NODE_TAG:
							read_CAMERA_NODE_TAG(head.length - 6);
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		private function read_OBJECT_NODE_TAG( chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			var nodeId: int = 0;
			var name: String = "";
			var meshIndex: int = 0;
			var mes: Mesh3DS;
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_NODE_ID:
							nodeId = read_NODE_ID();
						break;
					case CHUNK_NODE_HDR:
							name = read_NAME()
							for ( var i: int = 0; i < numMeshes; ++i )
							{
								if ( getMeshAt( i ).name == name )
								{
									meshIndex = i;
									break;
								}
							}
							mes = getMeshAt( meshIndex );
							mes.nodeId = nodeId;
							mes.nodeFlags = _fileData.readInt();
							mes.parentNodeId = _fileData.readUnsignedShort();
							if ( _decode )
							{
								_decode.enter();
								_decode.println( "Node flags: 0x" + mes.nodeFlags );
								_decode.println( "Parent node id: " + mes.parentNodeId );
								_decode.exit();
							}
							//FIXME Build hierarchy here...
						break;
					case CHUNK_PIVOT:
							mes.pivot.x = _fileData.readFloat();
							mes.pivot.y = _fileData.readFloat();
							mes.pivot.z = _fileData.readFloat();
							if ( _decode )
							{
								_decode.enter();
								_decode.println( "Pivot: " + mes.pivot );
								_decode.exit();
							}
						break;
					case CHUNK_POS_TRACK_TAG:
							read_POS_TRACK_TAG( mes.positionTrack );
						break;
					case CHUNK_ROT_TRACK_TAG:
							read_ROT_TRACK_TAG( mes.rotationTrack );
						break;
					case CHUNK_SCL_TRACK_TAG:
							read_POS_TRACK_TAG( mes.scaleTrack );
						break;
					case CHUNK_MORPH_TRACK_TAG:
							read_MORPH_TRACK_TAG( mes.morphTrack );
						break;
					case CHUNK_HIDE_TRACK_TAG:
							read_HIDE_TRACK_TAG( mes.hideTrack );
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		
		private function read_TARGET_NODE_TAG( chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			
			var targetNodeId: int = 0;
			var name: String = "";
			var cameraIndex: int = 0;
			var cam: Camera3DS;
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_NODE_ID:
							targetNodeId = read_NODE_ID();
						break;
					case CHUNK_NODE_HDR:
							name = read_NAME();
							for ( var i: int = 0; i < numCameras; ++i )
							{
								if ( getCameraAt( i ).name == name )
								{
									cameraIndex = i;
									break;
								}
							}
							cam = getCameraAt( cameraIndex );
							cam.targetNodeId = targetNodeId;
							cam.targetNodeFlags = _fileData.readInt();
							cam.targetParentNodeId = _fileData.readUnsignedShort();
							if ( _decode )
							{
								_decode.enter();
								_decode.println( "Target node flags: 0x" + cam.targetNodeFlags );
								_decode.println( "Target parent node id: " + cam.targetParentNodeId );
								_decode.exit();
							}
							// FIXME  Build hierarchy here...
						break;
					case CHUNK_POS_TRACK_TAG:
							read_POS_TRACK_TAG( cam.targetTrack );
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
			
		}
		
		private function read_CAMERA_NODE_TAG( chunkLength: int ): void
		{
			var chunkEnd: int = _fileData.position + chunkLength;
			
			if ( _decode )
			{
				_decode.enter();
			}
			
			var positionNodeId: int = 0;
			var name: String = "";
			var cameraIndex: int = 0;
			var cam: Camera3DS;
			
			while ( _fileData.position < chunkEnd )
			{
				var head: Head = read_HEAD();
				switch( head.id )
				{
					case CHUNK_NODE_ID:
							positionNodeId = read_NODE_ID();
						break;
					case CHUNK_NODE_HDR:
							name = read_NAME();
							for ( var i: int = 0; i < numCameras; ++i )
							{
								if ( getCameraAt( i ).name == name )
								{
									cameraIndex = i;
									break;
								}
							}
							cam = getCameraAt( cameraIndex );
							cam.positionNodeId = positionNodeId;
							cam.positionNodeFlags = _fileData.readInt();
							cam.positionParentNodeId = _fileData.readUnsignedShort();
							if ( _decode )
							{
								_decode.enter();
								_decode.println( "Position node flags: 0x" + cam.positionNodeFlags.toString( 16 ) );
								_decode.println( "Position parent node id: " + cam.positionParentNodeId );
								_decode.exit();
							}
						// FIXME Build hierarchy here...
						break;
					case CHUNK_POS_TRACK_TAG:
							read_POS_TRACK_TAG( cam.positionTrack );
						break;
					case CHUNK_FOV_TRACK_TAG:
							readPTrack( cam.fovTrack );
						break;
					case CHUNK_ROLL_TRACK_TAG:
							readPTrack( cam.rollTrack );
						break;
					default:
							skipChunk( head.length - 6 );
						break;
				}
			}
		}
		
		
		private function read_NODE_ID(): int
		{
			var id: int = _fileData.readUnsignedShort();
			
			if ( _decode )
			{
				_decode.enter();
				_decode.println( "Node id: " + id );
				_decode.exit();
			}
			
			return id;
		}
		
		private function readTrackHead( track: Track3DS ): int
		{
			var keys: int = 0;
			var flags: int = 0;
			
			track.flags = flags = _fileData.readUnsignedShort();
			
			if ( _decode )
			{
				var loop: String = "";
				switch( track.loopType )
				{
					case Track3DS.SINGLE:
							loop = "SINGLE";
						break;
					case Track3DS.REPEAT:
							loop = "REPEAT";
						break;
					case Track3DS.LOOP:
							loop = "LOOP";
						break;
					default:
							loop = "" + track.loopType;
						break;
				}
				_decode.println( "Loop type: " + loop );
			}
			
			skipBytes( 2 * 4 );
			
			keys = _fileData.readInt();
			
			if ( _decode )
			{
				_decode.println( " Keys: " + keys );
			}
			
			return keys;
		}
		
		private function readSplineParams( key: SplineKey3DS ): void
		{
			var flags: int = _fileData.readUnsignedShort();
			
			if ( flags != 0 )
			{
				if ( (flags & 0x01 ) != 0 )
				{
					key.tension = _fileData.readFloat();
					if ( _decode )
					{
						_decode.println( "\tTension:    " + key.tension )
					}
				}
				if ( (flags & 0x02 ) != 0 )
				{
					key.bias = _fileData.readFloat();
					if ( _decode )
					{
						_decode.println( "    Bias:       " + key.bias );
					}
				}
				if ( (flags & 0x04 ) != 0 )
				{
					key.continuity = _fileData.readFloat();
					if ( _decode )
					{
						_decode.println( "    Continuity: " + key.continuity );
					}
				}
				if ( (flags & 0x08 ) != 0 )
				{
					key.easeTo = _fileData.readFloat();
					if ( _decode )
					{
						_decode.println( "    Ease to:    " + key.easeTo );
					}
				}
				if ( (flags & 0x10 ) != 0 )
				{
					key.easeFrom = _fileData.readFloat();
					if ( _decode )
					{
						_decode.println( "    Ease from:  " + key.easeFrom );
					}
				}
			}
		}
		
		
		private function readPTrack( track: PTrack3DS ): void
		{
			if ( _decode )
			{
				_decode.enter();
			}
			
			var keys: int = readTrackHead( track );
			track.keys = new Vector.<PKey3DS>( keys );
			
			for ( var i: int = 0; i < keys; ++i )
			{
				var key: PKey3DS = new PKey3DS();
				key.frame = _fileData.readInt();
				if ( _decode )
				{
					_decode.println( "  Frame: " + key.frame );
				}
				
				readSplineParams( key );
				
				key.p = _fileData.readFloat();
				
				if ( _decode )
				{
					_decode.println( "  " + key.p );
				}
				track.keys[ i ] = key;
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		private function read_POS_TRACK_TAG( track: XYZTrack3DS ): void
		{
			if ( _decode )
			{
				_decode.enter();
			}
			
			var keys: int = readTrackHead( track );
			track.keys = new Vector.<XYZKey3DS>( keys );
			
			for ( var i: int = 0; i < keys; ++i )
			{
				var key: XYZKey3DS = new XYZKey3DS();
				key.frame = _fileData.readInt();
				if ( _decode )
				{
					_decode.println( "  Frame: " + key.frame );
				}
				
				readSplineParams( key );
				key.x = _fileData.readFloat();
				key.y = _fileData.readFloat();
				key.z = _fileData.readFloat();
				
				if ( _decode )
				{
					_decode.println( "key x: " + key.x );
					_decode.println( "key y: " + key.y );
					_decode.println( "key z: " + key.z );
				}
				
				track.keys[ i ] = key;
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		
		private function read_ROT_TRACK_TAG( track: RotationTrack3DS ): void
		{
			if ( _decode )
			{
				_decode.enter();
			}
			
			var keys: int = readTrackHead( track );
			track.keys = new Vector.<RotationKey3DS>( keys );
			
			for ( var i: int = 0; i < keys; ++i )
			{
				var key: RotationKey3DS = new RotationKey3DS();
				key.frame = _fileData.readInt();
				if ( _decode )
				{
					_decode.println( "  Frame: " + key.frame );
				}
				
				readSplineParams( key );
				key.a = _fileData.readFloat();
				key.x = _fileData.readFloat();
				key.z = _fileData.readFloat();
				key.y = _fileData.readFloat();
				
				if ( _decode )
				{
					_decode.println( "     A: " + key.a );
					_decode.println( "     X: " + key.x );
					_decode.println( "     Y: " + key.y );
					_decode.println( "     Z: " + key.z );
				}
				
				track.keys[ i ] = key;
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		
		private function read_MORPH_TRACK_TAG( track: MorphTrack3DS ): void
		{
			if ( _decode )
			{
				_decode.enter();
			}
			
			var keys: int = readTrackHead( track );
			track.keys = new Vector.<MorphKey3DS>( keys );
			
			for ( var i: int = 0; i < keys; ++i )
			{
				var key: MorphKey3DS = new MorphKey3DS();
				key.frame = _fileData.readInt();
				
				if ( _decode )
				{
					_decode.println( "  Frame: " + key.frame );
				}
				readSplineParams( key );
				var name: String = read_NAME();
				
				for ( var n: int = 0; n < numMeshes; ++n )
				{
					if ( getMeshAt( n ).name == name )
					{
						key.mesh = n;
						break;
					}
				}
				
				track.keys[ i ] = key;
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		private function read_HIDE_TRACK_TAG( track: HideTrack3DS ): void
		{
			if ( _decode )
			{
				_decode.enter();
			}
			
			var dummy: SplineKey3DS = new SplineKey3DS();
			var keys: int = readTrackHead( track );
			track.keys = new Vector.<HideKey3DS>( keys );
			
			for ( var i: int = 0; i < keys; ++i )
			{
				var key: HideKey3DS = new HideKey3DS();
				key.frame = _fileData.readInt();
				if ( _decode )
				{
					_decode.println( "  Frame: " + key.frame );
				}
				readSplineParams( dummy );
				track.keys[ i ] = key;
			}
			
			if ( _decode )
			{
				_decode.exit();
			}
		}
		
		public static const CHUNK_COL_RGB: int = 0x0010;
		public static const CHUNK_COL_TRU: int = 0x0011;
		public static const CHUNK_COL_LINRGB: int = 0x0012;
		public static const CHUNK_COL_LINTRU: int = 0x0013;
		
		public static const CHUNK_PERCENTW: int = 0x0030;		// int2   percentage
		public static const CHUNK_PERCENTF: int = 0x0031;		// float4  percentage
		
		public static const CHUNK_M3DMAGIC: int = 0x4D4D;
		public static const CHUNK_MDATA: int = 0x3D3D;
		public static const CHUNK_MAT_ENTRY: int = 0xAFFF;
		public static const CHUNK_MAT_NAME: int = 0xA000;
		public static const CHUNK_MAT_AMBIENT: int = 0xA010;
		public static const CHUNK_MAT_DIFFUSE: int = 0xA020;
		public static const CHUNK_MAT_SPECULAR: int = 0xA030;
		public static const CHUNK_MAT_SHININESS: int = 0xA041;
		public static const CHUNK_MAT_TRANSPARENCY: int = 0xA050;
		public static const CHUNK_MAT_MAP: int = 0xA200;
		public static const CHUNK_MAT_MAPNAME: int = 0xA300;
		public static const CHUNK_NAMED_OBJECT: int = 0x4000;
		public static const CHUNK_N_TRI_OBJECT: int = 0x4100;
		public static const CHUNK_POINT_ARRAY: int = 0x4110;
		public static const CHUNK_TEX_VERTS: int = 0x4140;
		public static const CHUNK_MESH_TEXTURE_INFO: int = 0x4170;
		public static const CHUNK_MESH_MATRIX: int = 0x4160;
		public static const CHUNK_MESH_COLOR: int = 0x4165;
		public static const CHUNK_FACE_ARRAY: int = 0x4120;
		public static const CHUNK_MSH_MAT_GROUP: int = 0x4130;
		public static const CHUNK_SMOOTH_GROUP: int = 0x4150;
		public static const CHUNK_N_LIGHT: int = 0x4600;
		public static const CHUNK_LIT_SPOT: int = 0x4610;
		public static const CHUNK_LIT_OFF: int = 0x4620;
		public static const CHUNK_LIT_ATTENUATE: int = 0x4625;
		public static const CHUNK_LIT_RAYSHAD: int = 0x4627;
		public static const CHUNK_LIT_SHADOWED: int = 0x4630;
		public static const CHUNK_LIT_LOCAL_SHADOW: int = 0x4640;
		public static const CHUNK_LIT_LOCAL_SHADOW2: int = 0x4641;
		public static const CHUNK_LIT_SEE_CONE: int = 0x4650;
		public static const CHUNK_LIT_SPOT_RECTANGULAR: int = 0x4651;
		public static const CHUNK_LIT_SPOT_OVERSHOOT: int = 0x4652;
		public static const CHUNK_LIT_SPOT_PROJECTOR: int = 0x4653;
		public static const CHUNK_LIT_SPOT_RANGE: int = 0x4655;
		public static const CHUNK_LIT_SPOT_ROLL: int = 0x4656;
		public static const CHUNK_LIT_SPOT_ASPECT: int = 0x4657;
		public static const CHUNK_LIT_RAY_BIAS: int = 0x4658;
		public static const CHUNK_LIT_INNER_RANGE: int = 0x4659;
		public static const CHUNK_LIT_OUTER_RANGE: int = 0x465A;
		public static const CHUNK_LIT_MULTIPLIER: int = 0x465B;
		public static const CHUNK_N_CAMERA: int = 0x4700;
		public static const CHUNK_CAM_SEE_CONE: int = 0x4710;
		public static const CHUNK_CAM_RANGES: int = 0x4720;
		public static const CHUNK_KFDATA: int = 0xB000;
		public static const CHUNK_KFSEG: int = 0xB008;
		public static const CHUNK_OBJECT_NODE_TAG: int = 0xB002;
		public static const CHUNK_NODE_ID: int = 0xB030;
		public static const CHUNK_NODE_HDR: int = 0xB010;
		public static const CHUNK_PIVOT: int = 0xB013;
		public static const CHUNK_POS_TRACK_TAG: int = 0xB020;
		public static const CHUNK_ROT_TRACK_TAG: int = 0xB021;
		public static const CHUNK_SCL_TRACK_TAG: int = 0xB022;
		public static const CHUNK_MORPH_TRACK_TAG: int = 0xB026;
		public static const CHUNK_HIDE_TRACK_TAG: int = 0xB029;
		public static const CHUNK_TARGET_NODE_TAG: int = 0xB004;
		public static const CHUNK_CAMERA_NODE_TAG: int = 0xB003;
		public static const CHUNK_FOV_TRACK_TAG: int = 0xB023;
		public static const CHUNK_ROLL_TRACK_TAG: int = 0xB024;
		// public static const CHUNK_AMBIENT_NODE_TAG: int = 0xB001;
		
	}

}

internal class Head
{
	public var id: int = 0;
	public var length: int = 0;
	
	public function Head( id: int, length: int )
	{
		this.id = id;
		this.length = length;
	}
}