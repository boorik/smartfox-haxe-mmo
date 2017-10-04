package view;
import interfaces.IView;

/**
 * ...
 * @author vincent blanchet
 */
class ClientView implements IView
{
	public var mainScreen:view.MainScreen;
	public var moveCB:Float->Float->Void;
	var avatars:Map<Int,Avatar>;
	public function new() 
	{
		avatars = new Map<Int,Avatar>();
		mainScreen = new view.MainScreen();

		var a = new view.Avatar(-1, "me");
		a.x = (400 - a.width)/2;
		a.y = (200 - a.height)/2;
		mainScreen.addChild(a);

		mainScreen.world.addEventListener(flash.events.MouseEvent.CLICK,onMouseClick);
	}

	public function log(value:String)
	{
		mainScreen.log(value);
	}

	public function createAvatar(id:Int, name:String, x:Float, y:Float):Void
	{
		//trace("create Avatar at "+x+", "+y);
		var a = new view.Avatar(id, name);
		a.x = x;
		a.y = y;
		mainScreen.world.addChild(a);
		avatars.set(id,a);
	}
	public function moveAvatar(id:Int, x:Float, y:Float):Void
	{
		var a = avatars.get(id);
		motion.Actuate.tween(a,0.5,{x:x-16,y:y-16},true);
	}
	public function removeAvatar(id:Int):Void
	{
		trace("removeAvatar "+id);
		mainScreen.world.removeChild(avatars.get(id));
		avatars.remove(id);
	}

	function onMouseClick(e:flash.events.MouseEvent)
	{
		trace("clicked");
		mainScreen.moveTo(e.localX,e.localY);
		moveCB(e.localX,e.localY);
	}

	public function init(x:Float,y:Float)
	{
		mainScreen.moveTo(x,y);
	}
}