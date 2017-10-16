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
		
		var body = new flash.display.Sprite();
		body.graphics.beginFill(Std.random(0xFFFFFF));
		body.graphics.drawRect(0, 0, 32, 32);
		body.graphics.endFill();
		
		var nameTF = new flash.text.TextField();
		nameTF.text = name;
		nameTF.width = 32;
		nameTF.height = 32;
		nameTF.wordWrap = true;
		nameTF.selectable = false;
		nameTF.mouseEnabled = false;
		body.addChild(nameTF);
		
		body.x = body.y = - body.width/2;
		
		addChild(body);
		
		//mouseChildren = false;
		//mouseEnabled = false;
	}
	
}