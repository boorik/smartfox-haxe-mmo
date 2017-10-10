package view;
import interfaces.IView;
import com.smartfoxserver.v2.entities.Buddy;
/**
 * ...
 * @author vincent blanchet
 */
class ClientView implements IView extends flash.display.Sprite
{
	public var mainScreen:view.MainScreen;

	public var moveCB(default,set):Float->Float->Void;
	public var onAvatarClickedCB:Int->Void;
	public var onBuddyClickedCB:Buddy->Void;
	public var onTextInputCB:String->Void;

	var avatars:Map<Int,Avatar>;
	var buddyListView:view.BuddyListView;
	var chatView:view.ChatView;
	var login:view.LoginView;
	public function new() 
	{
		super();

		avatars = new Map<Int,Avatar>();
		mainScreen = new view.MainScreen();
		addChild(mainScreen);

		buddyListView = new view.BuddyListView();
		buddyListView.onBuddyClicked = onBuddyClicked;
		buddyListView.x = Globals.clientWidth*Globals.gameViewWidthRatio;
		addChild(buddyListView);

		createMe();

		mainScreen.world.addEventListener(flash.events.MouseEvent.CLICK,onMouseClick);

		chatView = new view.ChatView();
		chatView.onTextInput = onTextInput;
		chatView.y = mainScreen.dHeight;
		addChild(chatView);
	}

	function set_moveCB(value:Float->Float->Void):Float->Float->Void
	{
		moveCB = value;
		mainScreen.moveCB = value;
		return moveCB;
	}
	function createMe()
	{
		var a = new view.Avatar(-1, "me");
		a.x = (mainScreen.dWidth - a.width)/2;
		a.y = (mainScreen.dHeight - a.height)/2;
		mainScreen.addChild(a);
	}

	public function log(value:String)
	{
		chatView.append(value);
	}

	public function createAvatar(id:Int, name:String, x:Float, y:Float):Void
	{
		//trace("create Avatar at "+x+", "+y);
		var a = new view.Avatar(id, name);
		a.x = x-a.width/2;
		a.y = y-a.height/2;
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
		mainScreen.moveTo(e.localX,e.localY);
		//moveCB(e.localX,e.localY);
	}

	function onAvatarClick(e:flash.events.MouseEvent)
	{
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

	function onTextInput(t:String)
	{
		onTextInputCB(t);
	}

	public function displayPublicMessage(msg:String)
	{
		chatView.append(msg);
	}

	public function displayAOI(width:Int,height:Int)
	{
		mainScreen.displayAOI(width,height);
	}

	public function showLogin(n:String,cb:String->Void):Void
	{
		login = new view.LoginView(n,cb);
		login.x = (mainScreen.dWidth - login.width)/2;
		login.y = (mainScreen.dHeight  - login.height)/2;
		addChild(login);
	}
	public function hideLogin():Void
	{
		removeChild(login);
	}
}