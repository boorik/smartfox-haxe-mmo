package view;

import interfaces.IView;
import com.smartfoxserver.v2.entities.Buddy;
import flash.display.Sprite;
import motion.easing.Linear;

/**
 * ...
 * @author vincent blanchet
 */
class ClientView implements IView extends flash.display.Sprite
{
	public var mainScreen:view.MainScreen;

	public var moveCB(default,set):Float->Float->String->Void;
	public var onAvatarClickedCB:Int->Void;
	public var onItemClickedCB:Int->Void;
	public var onBuddyClickedCB:Buddy->Void;
	public var onTextInputCB:String->Void;
	public var onMapSelected:String->Void;

	var avatars:Map<Int,Avatar>;
	var items:Map<Int,Barrel>;
	var buddyListView:view.BuddyListView;
	var chatView:view.ChatView;
	var login:view.LoginView;
	var mapSelector:LevelSelectView;
	var maps:Array<Sprite>;
	var me:view.Avatar;
	
	public function new() 
	{
		super();

		avatars = new Map<Int,Avatar>();
		items = new Map<Int,Barrel>();
		mainScreen = new view.MainScreen();
		addChild(mainScreen);

		#if !noBuddyList
		buddyListView = new view.BuddyListView();
		buddyListView.onBuddyClicked = onBuddyClicked;
		buddyListView.x = Globals.clientWidth*Globals.gameViewWidthRatio;
		addChild(buddyListView);
		#end

		chatView = new view.ChatView();
		chatView.onTextInput = onTextInput;
		chatView.y = mainScreen.dHeight;
		addChild(chatView);
	}

	function set_moveCB(value:Float->Float->String->Void):Float->Float->String->Void
	{
		moveCB = value;
		//mainScreen.moveCB = value;
		return moveCB;
	}

	public function log(value:String)
	{
		chatView.append(value);
	}

	public function createItem(id:Int, name:String, x:Float, y:Float,isOpen:Bool):Void
	{
		var item = new view.Barrel(id,isOpen,onItemClickedCB);
		item.x = x;
		item.y = y;
		items.set(id,item);
		mainScreen.addMapObject(item);

	}

	public function removeItem(id:Int)
	{
		var item = items.get(id);
		mainScreen.removeMapObject(item);
		item.destroy();
	}

	public function createAvatar(id:Int, name:String, x:Float, y:Float,isMe:Bool=false):Void
	{
		//trace("create Avatar at "+x+", "+y);
		var a = new view.Avatar(id, name);
		a.x = x;
		a.y = y;
		if (isMe)
		{
			a.mouseEnabled = false;
			a.mouseChildren = false;
			me = a;
			mainScreen.moveTo(x,y);
		}else{
			a.addEventListener(flash.events.MouseEvent.CLICK, onAvatarClick);
		}
		mainScreen.addMapObject(a);
		avatars.set(id, a);
		

		mainScreen.arrangeMapObject();
	}

	public function moveAvatar(id:Int, px:Float, py:Float,dir:String,isMe:Bool=false):Void
	{
		//trace("id:"+id);
		var a = avatars.get(id);
		a.dir = dir;
		a.body.showBehavior("avatar"+dir);

		if(px != a.x && py!=a.y)
		{

			// Calculate animation duration
			// (we want the avatar to move at a constant speed)
			var dx = px - a.x;
			var dy = py - a.y;
			var dist = Math.round(Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2)));

			var duration = dist / a.speed;
			var t = motion.Actuate.tween(a, duration, {x:px, y:py}).ease(Linear.easeNone);
			if (isMe)
			{
				t.onUpdate(cbm);
				t.onComplete(function(){cbm();a.body.showBehavior("avatarStand");});
			}else{
				t.onComplete(function(){mainScreen.arrangeMapObject();a.body.showBehavior("avatarStand");});
			}
		}
	}
	
	/**
	* Callback after each animation frame 
	**/
	function cbm()
	{
		moveCB(me.x, me.y,me.dir);
		mainScreen.moveTo(me.x, me.y);
		mainScreen.arrangeMapObject();
	}

	public function removeAvatar(id:Int):Void
	{
		trace("removeAvatar "+id);
		var a = avatars.get(id);
		a.removeEventListener(flash.events.MouseEvent.CLICK,onAvatarClick);
		mainScreen.removeMapObject(a);
		avatars.remove(id);
	}

	function onMouseClick(e:flash.events.MouseEvent)
	{
		
		var destX = e.localX;
		var destY = e.localY;

		//Is the destination valid?
		if(!mainScreen.isValidClickPosition(Std.int(destX),Std.int(destY)))
		{
			trace("not a valid position");
			return;
		}

		// Evaluate avatar movement direction
		var dx = destX - me.x;
		var dy = destY - me.y;

		var angle = Math.atan(dy / dx);

		var deg = Math.round(angle * 180 / Math.PI);
		if(dx < 0)
			deg += 180;
		else if(dx >= 0 && dy < 0)
			deg += 360;

		var dirIndex = Math.round(deg / 45);
		if (dirIndex >= Globals.AVATAR_DIRECTIONS.length)
			dirIndex -= Globals.AVATAR_DIRECTIONS.length;

		var dir = Globals.AVATAR_DIRECTIONS[dirIndex];


		moveAvatar(me.id, e.localX, e.localY,dir,true);
		
		//mainScreen.moveTo(e.localX,e.localY);
		//moveCB(e.localX,e.localY);
	}

	function onAvatarClick(e:flash.events.MouseEvent)
	{
		trace("avatar clicked");
		onAvatarClickedCB(cast(cast(e.target,Sprite).parent,Avatar).id);
		e.stopImmediatePropagation();

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

	public function displayPublicMessage(id:Int,name:String,msg:String)
	{
		var a = avatars.get(id);
		if(a != null)
			a.say(msg);
		chatView.append(name+" : "+msg);
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
			var bmp = new flash.display.Bitmap(openfl.Assets.getBitmapData("images/"+m.fileName+"-background.jpg"));
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

	public function loadMap(name:String,hitmap:flash.display.BitmapData)
	{
		trace("searched:"+name);
		var m:Sprite = maps.filter(function(s:Sprite){return s.name == name; })[0];
		trace("map:" + maps);
		m.scaleX = 1;
		m.scaleY = 1;
		mainScreen.world = m;
		mainScreen.hitmap = hitmap;
		//addChild(new flash.display.Bitmap(hitmap));
		mainScreen.world.addEventListener(flash.events.MouseEvent.CLICK,onMouseClick);
	}

}