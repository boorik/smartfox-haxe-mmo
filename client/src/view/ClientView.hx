package view;
import interfaces.IView;
import com.smartfoxserver.v2.entities.Buddy;
import flash.display.Sprite;
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
	public var onMapSelected:String->Void;

	var avatars:Map<Int,Avatar>;
	var buddyListView:view.BuddyListView;
	var chatView:view.ChatView;
	var login:view.LoginView;
	var mapSelector:LevelSelectView;
	var maps:Array<Sprite>;
	
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
		mainScreen.addMapObject(a);
		avatars.set(id,a);

		mainScreen.arrangeMapObject();
	}

	public function moveAvatar(id:Int, px:Float, py:Float):Void
	{
		trace("id:"+id);
		var a = avatars.get(id);
		if(px != a.x && py!=a.y)
		{
			var t = motion.Actuate.tween(a,0.5,{x:px-16,y:py-16});
			t.onComplete(mainScreen.arrangeMapObject);
		}
	}

	public function removeAvatar(id:Int):Void
	{
		trace("removeAvatar "+id);
		var a = avatars.get(id);
		a.removeEventListener(flash.events.MouseEvent.CLICK,onAvatarClick);
		mainScreen.world.removeChild(a);
		mainScreen.removeMapObject(a);
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

	public function showLevelSelect(mapItems:Map<String,MapData>)
	{
		maps = [];
		for (m in mapItems)
		{
			var map = new flash.display.Sprite();
			map.name = m.name;
			var bmp = new flash.display.Bitmap(flash.Assets.getBitmapData("images/"+m.fileName+"-background.jpg"));
			map.addChild(bmp);
			for(item in m.itemDatas)
			{
				for(p in item.coordinates)
				{
					var deco = new flash.display.Bitmap(item.bitmapdata);
					deco.x = -item.regX;
					deco.y = -item.regY;
					var cont = new flash.display.Sprite();
					cont.mouseEnabled = false;
					cont.addChild(deco);
					cont.x = p.x;
					cont.y = p.y;
					map.addChild(cont);
				}
			}
			maps.push(map);
		}

		mapSelector = new LevelSelectView(maps,onMapSelected);
		mapSelector.x = (mainScreen.dWidth - mapSelector.width)/2;
		mapSelector.y = (mainScreen.dHeight  - mapSelector.height)/2;
		addChild(mapSelector);
	}

	public function hideLevelSelect()
	{
		removeChild(mapSelector);
		mapSelector.destroy();
	}

	public function loadMap(name:String)
	{
		var m = maps.filter(function(s:Sprite){return s.name==name;})[0];
		m.scaleX = m.scaleY = 1;
		mainScreen.world = m;
		mainScreen.world.addEventListener(flash.events.MouseEvent.CLICK,onMouseClick);
	}

}