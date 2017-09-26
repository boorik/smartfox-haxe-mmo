package;

import com.smartfoxserver.v2.extensions.BaseServerEventHandler;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;
import Game;
/**
 * ...
 * @author vincent blanchet
 */

 @:nativeGen
class UserDisconnectedHandler extends BaseServerEventHandler
{

	@:overload
	override public function handleServerEvent(event:ISFSEvent):Void
	{
		var room = null;
		var joinedRooms:java.util.List<Room> = event.getParameter(cast SFSEventParam.JOINED_ROOMS);
		if (joinedRooms.size() > 0)
			room = joinedRooms.get(0);
		var user:User = event.getParameter(cast SFSEventParam.USER);
		this.trace(ExtensionLogLevel.WARN, java.NativeArray.make(user.getName() + " DISCONNECTED"));
		if (room != null)
		{
			Game.removeUserFromGame(user, room, cast this.getParentExtension());
		}
	}
	
}