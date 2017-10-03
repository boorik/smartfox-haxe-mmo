package view;
import interfaces.IView;

/**
 * ...
 * @author vincent blanchet
 */
class ClientView implements IView
{
	public var mainScreen:view.MainScreen;
	var avatars:Map<Int,Avatar>;
	public function new() 
	{
		avatars = new Map<Int,Avatar>();
		mainScreen = new view.MainScreen();

		mainScreen.addEventListener(flash.events.MouseEvent.CLICK,)
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
		mainScreen.addChildAt(a,0);
		avatars.set(id,a);
	}
	public function moveAvatar(id:Int, x:Float, y:Float):Void
	{
		
	}
	public function removeAvatar(id:Int):Void
	{
		mainScreen.removeChild(avatars.get(id));
		avatars.remove(id);
	}
}