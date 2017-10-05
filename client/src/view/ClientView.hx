package view;
import interfaces.IView;
import com.smartfoxserver.v2.entities.Buddy;
/**
 * ...
 * @author vincent blanchet
 */
class ClientView implements IView
{
	public var mainScreen:view.MainScreen;
	public var moveCB:Float->Float->Void;
	public var onAvatarClickedCB:Int->Void;
	public var onBuddyClickedCB:Buddy->Void;
	var avatars:Map<Int,Avatar>;
	var buddyListView:view.BuddyListView;

	public function new() 
	{
		avatars = new Map<Int,Avatar>();
		mainScreen = new view.MainScreen();
		buddyListView = new view.BuddyListView();
		buddyListView.onBuddyClicked = onBuddyClicked;
		buddyListView.x = 400;
		mainScreen.addChild(buddyListView);

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
		a.addEventListener(flash.events.MouseEvent.CLICK,onAvatarClick);
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
		var a = avatars.get(id);
		a.removeEventListener(flash.events.MouseEvent.CLICK,onAvatarClick);
		mainScreen.world.removeChild(a);
		avatars.remove(id);
	}

	function onMouseClick(e:flash.events.MouseEvent)
	{
		trace("clicked");
		mainScreen.moveTo(e.localX,e.localY);
		moveCB(e.localX,e.localY);
	}

	function onAvatarClick(e:flash.events.MouseEvent)
	{
		trace("avatar clicked");
		onAvatarClickedCB(cast(e.target,Avatar).id);
	}

	public function init(x:Float,y:Float)
	{
		mainScreen.moveTo(x,y);
	}

	public function updateBuddyList(ab:Array<com.smartfoxserver.v2.entities.Buddy>)
	{
		buddyListView.update(ab);
	}

	function onBuddyClicked(b:Buddy)
	{
		onBuddyClickedCB(b);
	}
}