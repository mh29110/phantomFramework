/* Copyright (c) 2012 EL-EMENT saharan
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation  * files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy,  * modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 * ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package com.element.oimo.physics.test {
	import com.element.oimo.physics.collision.shape.BoxShape;
	import com.element.oimo.physics.collision.shape.CylinderShape;
	import com.element.oimo.physics.collision.shape.Shape;
	import com.element.oimo.physics.collision.shape.ShapeConfig;
	import com.element.oimo.physics.dynamics.RigidBody;
	import com.element.oimo.physics.dynamics.World;
	import com.element.oimo.physics.util.DebugDraw;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import io.plugin.utils.Stats;

	/**
	 * 動作テスト
	 * @author saharan
	 */
	[SWF(width = "640", height = "480", frameRate = "60")]
	public class CylinderTest2 extends Sprite {
		private var s3d:Stage3D;
		private var world:World;
		private var renderer:DebugDraw;
		private var rigid:RigidBody;
		private var count:uint;
		private var tf:TextField;
		private var fps:Number;
		private var l:Boolean;
		private var r:Boolean;
		private var u:Boolean;
		private var d:Boolean;
		private var ctr:RigidBody;
		
		public function CylinderTest2() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var debug:Stats = new Stats();
			debug.x = 570;
			addChild(debug);
			tf = new TextField();
			tf.selectable = false;
			tf.defaultTextFormat = new TextFormat("_monospace", 12, 0xffffff);
			tf.x = 0;
			tf.y = 0;
			tf.width = 400;
			tf.height = 400;
			addChild(tf);
			initWorld();
			fps = 0;
			
			s3d = stage.stage3Ds[0];
			s3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			s3d.requestContext3D();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				var code:uint = e.keyCode;
				if (code == Keyboard.W) {
					u = true;
				}
				if (code == Keyboard.S) {
					d = true;
				}
				if (code == Keyboard.A) {
					l = true;
				}
				if (code == Keyboard.D) {
					r = true;
				}
				if (code == Keyboard.SPACE) {
					initWorld();
				}
			});
			stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
				var code:uint = e.keyCode;
				if (code == Keyboard.W) {
					u = false;
				}
				if (code == Keyboard.S) {
					d = false;
				}
				if (code == Keyboard.A) {
					l = false;
				}
				if (code == Keyboard.D) {
					r = false;
				}
			});
			addEventListener(Event.ENTER_FRAME, frame);
		}
		
		private function initWorld():void {
			world = new World();
			if (!renderer) renderer = new DebugDraw(640, 480);
			renderer.setWorld(world);
			var rb:RigidBody;
			var s:Shape;
			var c:ShapeConfig = new ShapeConfig();
			// c.friction = 1;
			rb = new RigidBody();
			c.position.init(0, -1, 0);
			c.rotation.init();
			s = new BoxShape(32, 2, 32, c);
			//s = new CylinderShape(16, 2, c);
			rb.addShape(s);
			rb.setupMass(RigidBody.BODY_STATIC);
			world.addRigidBody(rb);
			
			for (var k:int = 0; k < 5; k++) {
				for (var j:int = 0; j < 5; j++) {
					for (var i:int = 0; i < 7; i++) {
						rb = new RigidBody();
						c.position.init((j - 2) * 1.4, i * 1.05 + 0.5, (k - 2) * 1.4);
						s = new CylinderShape(0.5 + Math.random() * 0.1 - 0.05, 1 + Math.random() * 0.1 - 0.05, c);
						rb.addShape(s);
						rb.orientation.s = Math.random();
						rb.orientation.x = Math.random() * 0.01 - 0.005;
						rb.orientation.y = 1;
						rb.orientation.z = Math.random() * 0.01 - 0.005;
						rb.orientation.normalize(rb.orientation);
						rb.setupMass();
						world.addRigidBody(rb);
					}
				}
			}
			
			c.density = 10;
			c.position.init(0, 2, 6);
			c.rotation.init();
			s = new BoxShape(2,2,2, c);
			ctr = new RigidBody();
			ctr.addShape(s);
			ctr.orientation.s = Math.random() - 0.5;
			ctr.orientation.x = Math.random() - 0.5;
			ctr.orientation.y = Math.random() - 0.5;
			ctr.orientation.z = Math.random() - 0.5;
			ctr.orientation.normalize(ctr.orientation);
			ctr.setupMass();
			world.addRigidBody(ctr);
		}
		
		private function onContext3DCreated(e:Event = null):void {
			renderer.setContext3D(s3d.context3D);
			renderer.camera(0, 2, 4);
		}
		
		private function frame(e:Event = null):void {
			count++;
			var ang:Number = (320 - mouseX) * 0.01 + Math.PI * 0.5;
			renderer.camera(
				ctr.position.x + Math.cos(ang) * 8,
				ctr.position.y + (240 - mouseY) * 0.1,
				ctr.position.z + Math.sin(ang) * 8,
				ctr.position.x - Math.cos(ang) * 2,
				ctr.position.y,
				ctr.position.z - Math.sin(ang) * 2
			);
			if (l) {
				ctr.linearVelocity.x -= Math.cos(ang - Math.PI * 0.5) * 0.8;
				ctr.linearVelocity.z -= Math.sin(ang - Math.PI * 0.5) * 0.8;
			}
			if (r) {
				ctr.linearVelocity.x -= Math.cos(ang + Math.PI * 0.5) * 0.8;
				ctr.linearVelocity.z -= Math.sin(ang + Math.PI * 0.5) * 0.8;
			}
			if (u) {
				ctr.linearVelocity.x -= Math.cos(ang) * 0.8;
				ctr.linearVelocity.z -= Math.sin(ang) * 0.8;
			}
			if (d) {
				ctr.linearVelocity.x += Math.cos(ang) * 0.8;
				ctr.linearVelocity.z += Math.sin(ang) * 0.8;
			}
			world.step();
			fps += (1000 / world.performance.totalTime - fps) * 0.5;
			if (fps > 1000 || fps != fps) {
				fps = 1000;
			}
			tf.text =
				"Rigid Body Count: " + world.numRigidBodies + "\n" +
				"Shape Count: " + world.numShapes + "\n" +
				"Contact Count: " + world.numContacts + "\n" +
				"Island Count: " + world.numIslands + "\n\n" +
				"Broad Phase Time: " + world.performance.broadPhaseTime + "ms\n" +
				"Narrow Phase Time: " + world.performance.narrowPhaseTime + "ms\n" +
				"Solving Time: " + world.performance.solvingTime + "ms\n" +
				"Updating Time: " + world.performance.updatingTime + "ms\n" +
				"Total Time: " + world.performance.totalTime + "ms\n" +
				"Physics FPS: " + fps.toFixed(2) + "\n"
			;
			renderer.render();
			var len:uint = world.numRigidBodies;
			var rbs:Vector.<RigidBody> = world.rigidBodies;
			for (var i:int = 0; i < len; i++) {
				var r:RigidBody = rbs[i];
				if (r.position.y < -12) {
					r.position.init(Math.random() * 8 - 4, Math.random() * 4 + 8, Math.random() * 8 - 4);
					r.linearVelocity.x *= 0.8;
					r.linearVelocity.z *= 0.8;
				}
			}
		}
		
	}

}