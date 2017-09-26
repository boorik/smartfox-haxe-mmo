package;

import motion.Actuate;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.MouseEvent;

/**
 * ...
 * @author vincent blanchet
 */
class Main extends Sprite 
{
	/**
	 * reference to all player avatars
	 */
	var avatars:Map<Int,Avatar>;
	var me:Avatar;
	var sfsHandler:SFSHandler;
	var logTextField:flash.text.TextField;
	public function new() 
	{
		super();
		avatars = new Map<Int,Avatar>();
		
		logTextField = new flash.text.TextField();
		logTextField.width = Lib.current.stage.stageWidth;
		addChild(logTextField);
		
		sfsHandler = new SFSHandler();
		sfsHandler.log = log;
		sfsHandler.onReady = onReady;
		sfsHandler.onMove = onMove;
		sfsHandler.connect();
		
		var b = new openfl.utils.ByteArray();
		log("endian:" + b.endian);
	}
	
	function log(value:String)
	{
		logTextField.appendText(value+"\n");
		logTextField.scrollV = logTextField.maxScrollV;
	}
	
	function onReady(startState:StartState)
	{
		//create all players
		for (p in startState.players)
		{
			var av = new Avatar(p.id,p.name);
			av.x = p.x;
			av.y = p.y;
			addChild(av);
			avatars.set(p.id, av);
			
			if (p.id == sfsHandler.me.id)
				this.me = av;
		}
		
		Lib.current.stage.addEventListener(MouseEvent.CLICK, onClick);
	}
	
	private function onClick(e:MouseEvent):Void 
	{
		trace("click");
		sfsHandler.move({user:me.id, x:Std.int(e.localX), y:Std.int(e.localY)});
	}
	
	function onMove(move:Move)
	{
		var av = avatars.get(move.user);
		Actuate.tween(av, .5, {x:move.x, y:move.y});
	}

}
