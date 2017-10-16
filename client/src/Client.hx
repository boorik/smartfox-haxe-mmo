package;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.entities.MMORoom;
import com.smartfoxserver.v2.entities.Room;
import interfaces.IView;
/**
 * ...
 * @author vincent blanchet
 */

class Client
{
	/**
	 * reference to all player avatars
	 */
	var players:Map<Int,Player>;
	var me:Player;
	var sfsHandler:SFSHandler;
	
	var itemsByRoomName:Map<String,MapData>;

	public var view:IView;

	var privReg = ~/^ *@[A-Z0-9.#]+ /i;
 	var targetReg = ~/[A-Z0-9.#]+/i;
	public function new() 
	{
		players = new Map<Int,Player>();
		
		view = new view.ClientView();
		view.onMapSelected = onMapSelected;
		view.showLogin("nick",init);
		
	}

	function onMapSelected(roomName:String)
	{
		trace("selected:"+roomName);
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
		sfsHandler.onBuddyList = displayBuddyList;
		sfsHandler.onPublicMessage = displayPublicMsg;
		sfsHandler.onLogin = onLogin;
		sfsHandler.connect(name);

		view.moveCB = sfsHandler.sendPosition;
	
		
	}

	function onLogin(ra:Array<Room>)
	{
		itemsByRoomName = new Map<String,MapData>();
		for(r in ra)
		{
			var mmoRoom:MMORoom = cast r;
			var setupObj = mmoRoom.getVariable("mapItems").getSFSObjectValue();
			var items = [];
			for(itemKey in setupObj.getKeys() )
			{
				var itemdata = setupObj.getSFSObject(itemKey);
				
				var item = new ItemData();
				item.bitmapdata = Globals.envBitmapDatas.get(itemKey);
				item.regX = itemdata.getInt("rx");
				item.regY = itemdata.getInt("ry");
				var coordsArray = itemdata.getIntArray("coords");
				item.coordinates = [];
				for(i in 0...Std.int(coordsArray.length/2))
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

	function onRoomJoined(roomName:String)
	{
		trace("roomName:" + roomName);
		view.hideLogin();

		trace(sfsHandler.me.getVariables());
		view.loadMap(roomName);
		view.init(10,10);
		sfsHandler.initBuddyList();
		view.onAvatarClickedCB = onAvatarClicked;
		view.onBuddyClickedCB = sfsHandler.removeBuddy;
		view.onTextInputCB = onTextInput;
		view.displayAOI(Std.int(sfsHandler.aoi().px), Std.int(sfsHandler.aoi().py));
		view.createAvatar(sfsHandler.me.id, "Me",10, 10,true);
	}
	
	function createPlayer(u:User)
	{
		var p = new Player();
		p.user = u;
		players.set(u.id,p);
		haxe.Timer.measure(view.createAvatar.bind(u.id, u.name, u.aoiEntryPoint.px, u.aoiEntryPoint.py));
	}

	function removeUser(u:User)
	{
		view.removeAvatar(u.id);
		players.remove(u.id);

	}

	function moveUser(u:User,x:Float,y:Float)
	{
		if(!u.isItMe)
			view.moveAvatar(u.id,x,y);
	}

	function displayBuddyList(bl:Array<Buddy>)
	{
		trace("buddies:"+bl);
		view.updateBuddyList(bl);
	}

	function onAvatarClicked(id:Int)
	{
		sfsHandler.addBuddy(players.get(id).user);
	}

	function displayPublicMsg(u:User,msg:String)
	{
		view.displayPublicMessage(u.name+" : "+msg);
	}

	function onTextInput(msg:String)
	{
		if(privReg.match(msg))
		{
			targetReg.match(privReg.matched(0));
			var t = targetReg.matched(0);
			trace("private message to "+t);
			sfsHandler.sendPrivate(t,msg);
		}else{
			sfsHandler.sendPublic(msg);
		}
	}
	
}