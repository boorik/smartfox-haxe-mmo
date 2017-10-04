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
	public var world:Sprite;
	public function new() 
	{
		super();

		world = new Sprite();
		addChild(world);
		createFloor();
		
		logTextField = new TextField();
		logTextField.width = Lib.current.stage.stageWidth;
		logTextField.x = 400;
		addChild(logTextField);

		graphics.beginFill(Std.random(0xFFFFFF));
		graphics.drawRect(0, 0, 600, 200);
		graphics.endFill();

		origin = new flash.geom.Point(200,100);
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
		var floorMask = new flash.display.Bitmap(new flash.display.BitmapData(400,200));
		addChild(floorMask);
		world.mask = floorMask;
		world.addChild(bmp);
	}

	public function moveTo(px:Float,py:Float)
	{
		motion.Actuate.tween(world,0.5,{x:(origin.x - px),y:(origin.y - py)},true);
		//world.x = origin.x - px;
		//world.y = origin.y - py;
	}
	
}