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
	}
	public function log(value:String)
	{
		mainScreen.log(value);
	}
	public function createAvatar(id:Int, name:String, x:Float, y:Float):Void
	{
		log("createAvatar");
		var a = new view.Avatar(id, name);
		a.x = x;
		a.y = y;
		mainScreen.addChild(a);
		avatars.set(id,a);
	}
	public function moveAvatar(name:String, x:Float, y:Float):Void
	{
		
	}
	public function removeAvatar(name:String):Void
	{
		
	}
}