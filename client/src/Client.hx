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
	public function new() 
	{
		players = new Map<Int,Player>();
		
		view = new view.ClientView();
	}
	
	public function init()
	{
		
		sfsHandler = new SFSHandler();
		sfsHandler.log = view.log;
		sfsHandler.onReady = onReady;
		sfsHandler.onUserAdded = createPlayer;
		sfsHandler.onUserRemoved = removeUser;
		sfsHandler.onUserMoved = moveUser;
		sfsHandler.onBuddyList = displayBuddyList;
		sfsHandler.connect();

		view.moveCB = sfsHandler.sendPosition;
		
	}

	function onReady()
	{
		trace(sfsHandler.me.getVariables());
		view.init(10,10);
		sfsHandler.initBuddyList();
		view.onAvatarClickedCB = onAvatarClicked;
		view.onBuddyClickedCB = sfsHandler.removeBuddy;
	}
	
	function createPlayer(u:User)
	{
		view.log("pl:"+u);
		view.log("createPlayer at "+u.aoiEntryPoint.px+", "+u.aoiEntryPoint.py);
		var p = new Player();
		p.user = u;
		players.set(u.id,p);
		view.createAvatar(u.id, u.name, u.aoiEntryPoint.px, u.aoiEntryPoint.py);
	}

	function removeUser(u:User)
	{
		view.removeAvatar(u.id);
		players.remove(u.id);

	}

	function moveUser(u:User,x:Float,y:Float)
	{
		trace("move user to "+x+", "+y);
		view.moveAvatar(u.id,x,y);
	}

	function displayBuddyList(bl:Array<Buddy>)
	{
		trace("buddies:"+bl);
		view.updateBuddyList(bl);
	}

	function onAvatarClicked(id:Int)
	{
		trace("players:"+players);
		trace("user id:"+id);
		trace("user:"+players.get(id).user);
		sfsHandler.addBuddy(players.get(id).user);
	}
	
}