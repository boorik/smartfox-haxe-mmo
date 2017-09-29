package interfaces;

/**
 * @author vincent blanchet
 */
interface IView 
{
	var mainScreen:view.MainScreen;
	function log(value:String):Void;
	function createAvatar(id:Int, name:String, x:Float, y:Float):Void;
	function moveAvatar(name:String, x:Float, y:Float):Void;
	function removeAvatar(name:String):Void;
}
