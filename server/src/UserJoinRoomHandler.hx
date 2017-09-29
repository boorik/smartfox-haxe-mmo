package;

import com.smartfoxserver.v2.entities.SFSRoom;
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
class UserJoinRoomHandler extends BaseServerEventHandler
{

	@:overload
	override public function handleServerEvent(event:ISFSEvent):Void
	{
		var room = null;
		var joinedRoom:SFSRoom = event.getParameter(cast SFSEventParam.ROOM);
		var user:User = event.getParameter(cast SFSEventParam.USER);
		this.trace(ExtensionLogLevel.WARN, java.NativeArray.make(user.getName() + " Joined room :"+joinedRoom));
	}
	
}