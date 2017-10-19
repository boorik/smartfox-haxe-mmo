package view;

/**
 * ...
 * @author vincent blanchet
 */
class Avatar extends openfl.display.Sprite
{
	public var id:Int;
	public var body:spritesheet.AnimatedSprite;
	public var speed = 100;
	public var dir:String;
	var lastTime:Float;
	public function new(id:Int,name:String) 
	{
		super();
		
		this.id = id;
		
		body = new spritesheet.AnimatedSprite(Globals.avatarSpriteSheet,true);
		body.x = -15;
		body.y = -36;
		addChild(body);
		
		var nameTF = new flash.text.TextField();
		nameTF.defaultTextFormat.align = "center";
		nameTF.autoSize = flash.text.TextFieldAutoSize.CENTER;
		nameTF.text = name;
		nameTF.x = - nameTF.width / 2;
		nameTF.y = - 36 - nameTF.height;
		//nameTF.wordWrap = true;
		nameTF.selectable = false;
		nameTF.mouseEnabled = false;
		addChild(nameTF);

		body.showBehavior("avatarStand");
		addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
		
		//mouseChildren = false;
		//mouseEnabled = false;
	}

	function onEnterFrame(e:flash.events.Event)
	{
		var time = openfl.Lib.getTimer();
 		var delta = time - lastTime;
		body.update(cast delta);	
		lastTime = time;
	}
	
}