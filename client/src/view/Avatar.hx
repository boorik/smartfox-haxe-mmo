package view;

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
		graphics.drawRect(0, 0, 32, 32);
		graphics.endFill();
		
		var nameTF = new flash.text.TextField();
		nameTF.text = name;
		nameTF.width = 32;
		nameTF.height = 32;
		nameTF.wordWrap = true;
		nameTF.selectable = false;
		nameTF.mouseEnabled = false;
		addChild(nameTF);
		
		//mouseChildren = false;
		//mouseEnabled = false;
	}
	
}