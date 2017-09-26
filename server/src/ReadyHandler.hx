package;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.SFSExtension;
import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.api.CreateRoomSettings;
import haxe.Timer;
import tools.SFSObjectTool;

/**
 * ...
 * @author vincent blanchet
 */

@:nativeGen
//@:meta(com.smartfoxserver.v2.annotations.MultiHandler)
class ReadyHandler extends BaseClientRequestHandler
{

	@:overload
	override public function handleClientRequest(player:User,  params:ISFSObject):Void
	{
		ready(player,cast params);
	}
	
	function ready(user:User,params:SFSObject)
	{
		this.trace(ExtensionLogLevel.WARN, java.NativeArray.make("User "+user.getName()+" is Ready"));
		
		var game:Game = cast(this.getParentExtension(), MMOExtension).games.get(user.getLastJoinedRoom().getId());
		if(game != null)
			game.playerReady(user);
		else{
			var errObj = SFSObjectTool.instanceToSFSObject("DISCONNECTION");
			this.getParentExtension().send(Commands.ERROR,errObj,user);
		}
	}	
}