package interfaces;

import com.smartfoxserver.v2.entities.Buddy;
/**
 * @author vincent blanchet
 */
interface IView 
{
	var moveCB:Float->Float->Void;
	var onAvatarClickedCB:Int->Void;
	var onBuddyClickedCB:Buddy->Void;
	var mainScreen:view.MainScreen;
	function log(value:String):Void;
	function createAvatar(id:Int, name:String, x:Float, y:Float):Void;
	function moveAvatar(id:Int, x:Float, y:Float):Void;
	function removeAvatar(id:Int):Void;
	function init(x:Float,y:Float):Void;
	function updateBuddyList(ab:Array<com.smartfoxserver.v2.entities.Buddy>):Void;
}
