package;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
//import com.smartfoxserver.v2.annotations.MultiHandler;
import haxe.Timer;
import tools.SFSObjectTool;
import MoveHandler;
/**
 * ...
 * @author vincent blanchet
 */

@:nativeGen
//@:meta(com.smartfoxserver.v2.annotations.MultiHandler)
class MoveHandler extends BaseClientRequestHandler
{

	@:overload
	override public function handleClientRequest(player:User,  params:ISFSObject):Void
	{
		move(player,cast params);
	}
	
	function move(user:User,params:SFSObject)
	{
		var m:Move = SFSObjectTool.sfsObjectToInstance(params);
		this.trace(ExtensionLogLevel.WARN, java.NativeArray.make(m));
		
		var game:Game = cast(this.getParentExtension(), MMOExtension).games.get(user.getLastJoinedRoom().getId());
		game.move(user, m);
	}	
}