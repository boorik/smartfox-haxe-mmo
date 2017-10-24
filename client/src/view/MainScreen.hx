package view;

import flash.display.Sprite;
import flash.display.BitmapData;
/**
 * ...
 * @author vincent blanchet
 */
class MainScreen extends flash.display.Sprite
{
	var origin:flash.geom.Point;
	var worldMask:Sprite;
	var tween:motion.actuators.GenericActuator<Dynamic>;
	var mapObjects:Array<flash.display.DisplayObject>;
	
	public var hitmap:BitmapData;
	public var world(default,set):Sprite;
	public var dWidth:Float;
	public var dHeight:Float;
	
	public function new() 
	{
		super();

		hitmap = openfl.Assets.getBitmapData("images/hitarea.png");
		
		//addChild(hitArea);
		dWidth = Globals.gameViewWidthRatio*Globals.clientWidth;
		dHeight = Globals.gameViewHeightRatio*Globals.clientHeight;

		//world = new Sprite();
		//addChild(world);
		//loadFloor();
		worldMask = new Sprite();
		worldMask.graphics.beginFill(0);
		worldMask.graphics.drawRect(0, 0, dWidth, dHeight);
		worldMask.graphics.endFill();
		addChild(worldMask);
		
		graphics.beginFill(Std.random(0xFFFFFF));
		graphics.drawRect(0, 0, dWidth, dHeight);
		graphics.endFill();
		

		origin = new flash.geom.Point(dWidth/2,dHeight/2);
	}

	function set_world(s:Sprite):Sprite
	{
		mapObjects = [];
		var index = -1;
		if(world != null && contains(world))
		{
			index = getChildIndex(world);
			removeChild(world);
		}
		world = s;
		world.mask = worldMask;
		addChildAt(world, (index == -1)?numChildren:index);

		//get all map objects for zsorting mechanic
		var tot = world.numChildren;
		while(tot>0)
		{
			tot--;
			mapObjects.push(world.getChildAt(tot));
		}
		
		return world;
	}

	public function moveTo(px:Float,py:Float)
	{
		world.x = origin.x - px;
		world.y = origin.y - py;
	}

	public function displayAOI(aoiWidth:Int,aoiHeight:Int):Void
	{
		var aoi = new Sprite();
		var px = (dWidth - 2*aoiWidth)/2;
		var py = (dHeight - 2*aoiHeight)/2;
		//aoi.graphics.beginFill(0,1);
		aoi.graphics.lineStyle(1,0,0.8);
		aoi.graphics.moveTo(px,py);
		aoi.graphics.lineTo(px+2*aoiWidth,py);
		aoi.graphics.lineTo(px+2*aoiWidth,py+2*aoiHeight);
		aoi.graphics.lineTo(px,py+2*aoiHeight);
		aoi.graphics.lineTo(px,py);
		
		//aoi.graphics.endFill();
		trace("==== "+px+", "+py+" w:"+aoiWidth+" h:"+aoiHeight);
		aoi.mouseChildren = false;
		aoi.mask = worldMask;
		addChild(aoi);
	}

	public function arrangeMapObject()
	{
		if(mapObjects.length > 1)
		{
			mapObjects.sort(function(a,b){
				if (a.y < b.y)
					return -1;
				if (a.y > b.y)
					return 1;

				return 0;
			});

			var tot = mapObjects.length;

			while(--tot>=0)
			{
				if(world.getChildIndex(mapObjects[tot])!= tot)
				{
					//trace("obj coords :"+mapObjects[tot].x+", "+mapObjects[tot].y);
					world.setChildIndex(mapObjects[tot],tot);
				}
			}
		}
		//trace(world.x + ", " + world.y+" "+world.width+"x"+world.height);

	}

	public function addMapObject(obj:flash.display.DisplayObject)
	{
		if(obj == null)
			throw "obj must not be null";
		mapObjects.push(obj);
		world.addChild(obj);
	}

	public function removeMapObject(obj:flash.display.DisplayObject)
	{
		mapObjects.remove(obj);
		world.removeChild(obj);
	}
	
	public function isValidClickPosition(px:Int,py:Int):Bool
	{
		trace(px+", "+py);
		trace(hitmap.width+"x"+hitmap.height);
		var c = hitmap.getPixel32(px,py);
		trace(c);
		trace(c >> 24 & 0xFF);
		return (c >> 24 & 0xFF) > 0;
	}
	
	
}