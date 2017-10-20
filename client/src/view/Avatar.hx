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
	var balloon:view.Balloon;
	var timer:Float;

	public function new(id:Int,name:String) 
	{
		super();
		
		this.id = id;
		lastTime = openfl.Lib.getTimer();

		body = new spritesheet.AnimatedSprite(Globals.avatarSpriteSheet,true);
		body.x = -15;
		body.y = -36;
		addChild(body);
		
		var nameTF = new flash.text.TextField();
		nameTF.defaultTextFormat.align = "center";
		nameTF.autoSize = flash.text.TextFieldAutoSize.CENTER;
		nameTF.text = name;
		nameTF.x = - nameTF.width / 2;
		nameTF.y = - 30 - nameTF.height;
		nameTF.selectable = false;
		nameTF.mouseEnabled = false;
		addChild(nameTF);

		balloon = new view.Balloon();
		balloon.y = nameTF.y + 10;
		balloon.visible = false;
		addChild(balloon);

		body.showBehavior("avatarStand");
		addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
	}

	public function say(txt:String)
	{
		balloon.updateText(txt);
		balloon.visible = true;
		timer = 2.;

	}

	function onEnterFrame(e:flash.events.Event)
	{
		var time = openfl.Lib.getTimer();
 		var delta = time - lastTime;
		body.update(cast delta);	
		lastTime = time;
		if(balloon.visible)
		{
			timer -= 0.01;
			if(timer<=0)
				balloon.visible = false;	
		}
	}
	
}