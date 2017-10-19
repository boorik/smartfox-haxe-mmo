package interfaces;

import com.smartfoxserver.v2.entities.Buddy;
/**
 * @author vincent blanchet
 */
interface IView 
{
	var moveCB(default,set):Float->Float->String->Void;
	var onAvatarClickedCB:Int->Void;
	var onBuddyClickedCB:Buddy->Void;
	var onTextInputCB:String->Void;
	var mainScreen:view.MainScreen;
	var onMapSelected:String->Void;
	
	function log(value:String):Void;
	function createAvatar(id:Int, name:String, x:Float, y:Float,isMe:Bool=false):Void;
	function moveAvatar(id:Int, x:Float, y:Float,dir:String,isMe:Bool=false):Void;
	function removeAvatar(id:Int):Void;
	function init(x:Float,y:Float):Void;
	function updateBuddyList(ab:Array<com.smartfoxserver.v2.entities.Buddy>):Void;
	function displayPublicMessage(msg:String):Void;
	function displayAOI(width:Int,height:Int):Void;
	function showLogin(name:String,cb:String->Void):Void;
	function hideLogin():Void;
	function showLevelSelect(mapItems:Map<String,MapData>):Void;
	function hideLevelSelect():Void;
	function loadMap(name:String):Void;
}
