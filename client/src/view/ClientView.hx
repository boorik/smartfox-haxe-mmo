package view;
import interfaces.IView;

/**
 * ...
 * @author vincent blanchet
 */
class ClientView implements IView
{
	public var mainScreen:view.MainScreen;
	public function new() 
	{
		mainScreen = new view.MainScreen();
	}
	public function log(value:String)
	{
		mainScreen.log(value);
	}
	public function createAvatar(id:Int, name:String, x:Float, y:Float):Void
	{
		var a = new view.Avatar(id, name);
		a.x = x;
		a.y = y;
		mainScreen.addChild(a);
	}
	public function moveAvatar(name:String, x:Float, y:Float):Void
	{
		
	}
	public function removeAvatar(name:String):Void
	{
		
	}
}