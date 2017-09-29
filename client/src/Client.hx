package;
import com.smartfoxserver.v2.entities.User;
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
		//sfsHandler.onReady = onReady;
		sfsHandler.onUserAdded = createPlayer;
		//sfsHandler.onMove = onMove;
		sfsHandler.connect();
	}
	
	function createPlayer(u:User)
	{
		var p = new Player();
		p.user = u;
		view.createAvatar(u.id, u.name, u.aoiEntryPoint.px, u.aoiEntryPoint.py);
	}
	
}