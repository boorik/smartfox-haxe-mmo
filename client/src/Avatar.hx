package;

/**
 * ...
 * @author vincent blanchet
 */
class Avatar extends openfl.display.Sprite
{
	public var id:Int;
	public function new(id:Int,name:String) 
	{
		super();
		
		this.id = id;
		
		graphics.beginFill(Std.random(0xFFFFFF));
		graphics.drawRect(0, 0, 100, 100);
		graphics.endFill();
		
		var nameTF = new flash.text.TextField();
		nameTF.text = name;
		addChild(nameTF);
		
		mouseChildren = false;
		mouseEnabled = false;
	}
	
}