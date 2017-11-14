package;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.entities.MMORoom;
import com.smartfoxserver.v2.entities.Room;

/**
 * ...
 * @author vincent blanchet
 */

class Client
{
	/**
	 * reference to all player avatars
	 */
	var players:Map<Int, Player>;
	var me:Player;
	var sfsHandler:SFSHandler;
	
	var itemsByRoomName:Map<String, MapData>;

	public var view:view.ClientView;

	var privReg = ~/^ *@[A-Z0-9.#]+ /i;
 	var targetReg = ~/[A-Z0-9.#]+/i;
	public function new() 
	{
		players = new Map<Int, Player>();
		
		view = new view.ClientView();
		view.onMapSelected = onMapSelected;
		view.showLogin("nick",init);
	}

	function onMapSelected(roomName:String)
	{
		view.hideLevelSelect();
		sfsHandler.joinRoom(roomName);
	}
	
	public function init(name:String)
	{
		sfsHandler = new SFSHandler();
		sfsHandler.log = view.log;
		sfsHandler.onRoomJoined = onRoomJoined;
		sfsHandler.onUserAdded = createPlayer;
		sfsHandler.onUserRemoved = removeUser;
		sfsHandler.onUserMoved = moveUser;
		#if !noBuddyList
		sfsHandler.onBuddyList = displayBuddyList;
		#end
		sfsHandler.onPublicMessage = displayPublicMsg;
		sfsHandler.onLogin = onLogin;
		sfsHandler.onItemAdded = createItem;
		sfsHandler.onItemRemoved = removeItem;
		
		sfsHandler.connect(name);

		view.moveCB = sfsHandler.sendPosition;
	}

	function onLogin(ra:Array<Room>)
	{
		itemsByRoomName = new Map<String, MapData>();

		for (r in ra)
		{
			var mmoRoom:MMORoom = cast r;
			var setupObj = mmoRoom.getVariable("mapItems").getSFSObjectValue();
			var items = [];

			for (itemKey in setupObj.getKeys() )
			{
				var itemdata = setupObj.getSFSObject(itemKey);
				var item = new ItemData();
				item.bitmapdata = Globals.envBitmapDatas.get(itemKey);
				item.regX = itemdata.getInt("rx");
				item.regY = itemdata.getInt("ry");
				item.coordinates = [];
				var coordsArray = itemdata.getIntArray("coords");
				for (i in 0...Std.int(coordsArray.length/2))
				{
					var index = i*2;
					item.coordinates.push(new flash.geom.Point(coordsArray[index],coordsArray[index+1]));
				}
				items.push(item);
			}

			var mapData = new MapData();
			mapData.name = mmoRoom.name;
			mapData.fileName = mmoRoom.name.toLowerCase();
			var reg = ~/ /g;
			mapData.fileName = reg.replace(mapData.fileName,"-");
			mapData.itemDatas = items;
			itemsByRoomName.set(mmoRoom.name,mapData);
		}

		view.showLevelSelect(itemsByRoomName);
	}

	function onRoomJoined(roomName:String, posX:Float, posY:Float, hitmap:flash.display.BitmapData)
	{
		trace("roomName:" + roomName);
		view.hideLogin();

		trace(sfsHandler.me.getVariables());
		view.loadMap(roomName,hitmap);
		view.init(10,10);

		#if !noBuddyList
		sfsHandler.initBuddyList();
		#end

		view.onAvatarClickedCB = onAvatarClicked;
		view.onBuddyClickedCB = sfsHandler.removeBuddy;
		view.onTextInputCB = onTextInput;
		view.onItemClickedCB = sfsHandler.itemClicked;
		view.displayAOI(Std.int(sfsHandler.aoi().px), Std.int(sfsHandler.aoi().py));
		view.createAvatar(sfsHandler.me.id, "Me",posX, posY,true);
	}
	
	function createPlayer(u:User)
	{
		trace('CREATE PLAYER $u');
		var p = new Player();
		p.user = u;
		players.set(u.id,p);
		view.createAvatar(u.id, u.name, u.aoiEntryPoint.px, u.aoiEntryPoint.py);
		trace('Done');
	}

	function createItem(i:com.smartfoxserver.v2.entities.MMOItem,isOpen:Bool)
	{
		view.createItem(cast i.id, "barrel_"+i.id, i.aoiEntryPoint.px, i.aoiEntryPoint.py, isOpen);
	}

	function removeUser(u:User)
	{
		view.removeAvatar(u.id);
		players.remove(u.id);
	}

	function moveUser(u:User,x:Float,y:Float,dir:String)
	{
		if(!u.isItMe)
			view.moveAvatar(u.id, x, y, dir);
	}

	function displayBuddyList(bl:Array<Buddy>)
	{
		view.updateBuddyList(bl);
	}

	function onAvatarClicked(id:Int)
	{
		var target = players.get(id).user;
		sfsHandler.addBuddy(target);
	}

	function displayPublicMsg(u:User,msg:String)
	{
		view.displayPublicMessage(u.id, (u.isItMe? "ME" : u.name), msg);
	}

	function onTextInput(msg:String)
	{
		if (privReg.match(msg))
		{
			targetReg.match(privReg.matched(0));
			var t = targetReg.matched(0);
			trace("private message to "+t);
			sfsHandler.sendPrivate(t,msg);
		}
		else
			sfsHandler.sendPublic(msg);
		
	}

	function removeItem(i:com.smartfoxserver.v2.entities.MMOItem)
	{
		view.removeItem(cast i.id);
	}
}