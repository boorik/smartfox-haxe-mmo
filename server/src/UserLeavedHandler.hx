package;

import com.smartfoxserver.v2.extensions.BaseServerEventHandler;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;
/**
 * ...
 * @author vincent blanchet
 */

 @:nativeGen
class UserLeavedHandler extends BaseServerEventHandler
{

	@:overload
	override public function handleServerEvent(event:ISFSEvent):Void
	{
		// Get room
		var room:Room = event.getParameter(cast SFSEventParam.ROOM);
		
		var user:User = event.getParameter(cast SFSEventParam.USER);
		this.trace(ExtensionLogLevel.WARN, java.NativeArray.make(user.getName() + " left the game"));
		if (room != null)
			Game.removeUserFromGame(user, room, cast this.getParentExtension());
	}
	
}