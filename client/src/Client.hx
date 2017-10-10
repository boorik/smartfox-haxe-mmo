package;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Buddy;
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
	
	public var view:IView;

	var privReg = ~/^ *@[A-Z0-9.#]+ /i;
 	var targetReg = ~/[A-Z0-9.#]+/i;
	public function new() 
	{
		players = new Map<Int,Player>();
		
		view = new view.ClientView();
		view.showLogin("nick",init);
		
	}
	
	public function init(name:String)
	{
		
		sfsHandler = new SFSHandler();
		sfsHandler.log = view.log;
		sfsHandler.onReady = onReady;
		sfsHandler.onUserAdded = createPlayer;
		sfsHandler.onUserRemoved = removeUser;
		sfsHandler.onUserMoved = moveUser;
		sfsHandler.onBuddyList = displayBuddyList;
		sfsHandler.onPublicMessage = displayPublicMsg;
		sfsHandler.connect(name);

		view.moveCB = sfsHandler.sendPosition;
	
		
	}

	function onReady()
	{
		view.hideLogin();

		trace(sfsHandler.me.getVariables());
		view.init(10,10);
		sfsHandler.initBuddyList();
		view.onAvatarClickedCB = onAvatarClicked;
		view.onBuddyClickedCB = sfsHandler.removeBuddy;
		view.onTextInputCB = onTextInput;
		view.displayAOI(Std.int(sfsHandler.aoi().px),Std.int(sfsHandler.aoi().py));
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