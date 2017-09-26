package;

import java.Lib;
import com.smartfoxserver.v2.extensions.SFSExtension;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;
import com.smartfoxserver.v2.core.SFSEventType;
/**
 * Main entry to user extension
 * @author vincent blanchet
 */
@:nativeGen
class MMOExtension extends SFSExtension
{
	public var games: java.util.concurrent.ConcurrentHashMap<Int,Game>;
	var timeController:TimeController;
	@:overload override public function init()
	{
		games = new java.util.concurrent.ConcurrentHashMap<Int,Game>();
		this.log("Extension started");
		
		/**
		 * Event handlers
		 */
		this.addEventHandler(SFSEventType.USER_JOIN_ZONE, cast(JoinZoneHandler, java.lang.Class<Dynamic>));
		this.addEventHandler(SFSEventType.USER_LEAVE_ROOM, cast(UserLeavedHandler, java.lang.Class<Dynamic>));
		this.addEventHandler(SFSEventType.USER_LOGOUT, cast(UserDisconnectedHandler, java.lang.Class<Dynamic>));
		this.addEventHandler(SFSEventType.USER_DISCONNECT, cast(UserDisconnectedHandler, java.lang.Class<Dynamic>));
		
		/**
		 * Request handlers
		 */
		//play game user want to start a game : getting free game room or creating one and warping him in
		this.addRequestHandler(Commands.PLAY, cast(PlayGameHandler,java.lang.Class<Dynamic>));
		this.addRequestHandler(Commands.MOVE, cast(MoveHandler, java.lang.Class<Dynamic>));
		this.addRequestHandler(Commands.READY, cast(ReadyHandler, java.lang.Class<Dynamic>));
		
		timeController = new TimeController(this);
		timeController.start();
		
	}
	
	/**
	 * enable easy hot reload
	 */
	@:overload override public function destroy()
	{
		timeController.halt = true;
		timeController = null;
		
		this.removeEventHandler(SFSEventType.USER_JOIN_ZONE);
		this.removeEventHandler(SFSEventType.USER_LEAVE_ROOM);
		this.removeEventHandler(SFSEventType.USER_LOGOUT);
		this.removeEventHandler(SFSEventType.USER_DISCONNECT);
		
		this.removeRequestHandler(Commands.PLAY);
		this.removeRequestHandler(Commands.MOVE);
		this.removeRequestHandler(Commands.READY);
	}
	
	public function log(obj:Dynamic):Void
	{
		this.trace(ExtensionLogLevel.WARN, java.NativeArray.make(Std.string(obj) ));
	}
	
	
	
}