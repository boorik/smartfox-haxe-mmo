package view;
import openfl.Lib;
import openfl.text.TextField;
import openfl.display.Sprite;
/**
 * ...
 * @author vincent blanchet
 */
class MainScreen extends openfl.display.Sprite
{
	public var logTextField:TextField;
	var origin:flash.geom.Point;
	var floorMask:flash.display.Bitmap;
	var tween:motion.actuators.GenericActuator<Dynamic>;
	public var world(default,set):Sprite;
	public var dWidth:Float;
	public var dHeight:Float;
	public var moveCB:Float->Float->Void;
	public function new() 
	{
		super();

		dWidth = Globals.gameViewWidthRatio*Globals.clientWidth;
		dHeight = Globals.gameViewHeightRatio*Globals.clientHeight;

		world = new Sprite();
		addChild(world);
		loadFloor();
		
		logTextField = new TextField();
		logTextField.width = Lib.current.stage.stageWidth;
		logTextField.x = dWidth;
		addChild(logTextField);

		graphics.beginFill(Std.random(0xFFFFFF));
		graphics.drawRect(0, 0, dWidth, dHeight);
		graphics.endFill();

		origin = new flash.geom.Point(dWidth/2,dHeight/2);
	}
	
	public function log(value:String)
	{
		logTextField.appendText(value+"\n");
		logTextField.scrollV = logTextField.maxScrollV;
	}

	function createFloor()
	{
		var width = 100;
		var height = 100;
		var tileVerticeSize = 32;
		var bmpdata = new flash.display.BitmapData(width*tileVerticeSize,height*tileVerticeSize,false,0x00FF00);
		var rect = new flash.geom.Rectangle(0,0,tileVerticeSize,tileVerticeSize);
		for(i in 0...width)
		{
			for(j in 0...height)
			{
				rect.x = i*tileVerticeSize;
				rect.y = j*tileVerticeSize;
				bmpdata.fillRect(rect,0x000050+i*j);
			}
		}
		var bmp = new flash.display.Bitmap(bmpdata);
		floorMask = new flash.display.Bitmap(new flash.display.BitmapData(Std.int(dWidth),Std.int(dHeight)));
		addChild(floorMask);
		world.mask = floorMask;
		world.addChild(bmp);
	}

	function loadFloor()
	{
		var bmp = new flash.display.Bitmap(flash.Assets.getBitmapData("images/background.jpg"));
		floorMask = new flash.display.Bitmap(new flash.display.BitmapData(Std.int(dWidth),Std.int(dHeight)));
		addChild(floorMask);
		world.mask = floorMask;
		world.addChild(bmp);
	}

	function set_world(s:Sprite):Sprite
	{
		var index = -1;
		if(contains(world))
		{
			index = getChildIndex(world);
			removeChild(world);
		}
		world = s;
		world.mask = floorMask;
		addChildAt(world,(index == -1)?numChildren:index);
		return world;
	}

	public function moveTo(px:Float,py:Float)
	{
		tween = motion.Actuate.tween(world,0.5,{x:(origin.x - px),y:(origin.y - py)},true);
		tween.onUpdate(moveCB,[origin.x - this.world.x,origin.y - this.world.y]);
		tween.onComplete(moveCB,[px,py]);
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
		aoi.mask = floorMask;
		addChild(aoi);
	}
	
}