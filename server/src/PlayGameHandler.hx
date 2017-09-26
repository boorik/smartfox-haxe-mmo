package;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.extensions.SFSExtension;
import com.smartfoxserver.v2.annotations.MultiHandler;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.api.CreateRoomSettings;
import haxe.Timer;
/**
 * ...
 * @author vincent blanchet
 */

@:nativeGen
//@:meta(com.smartfoxserver.v2.annotations.MultiHandler)
class PlayGameHandler extends BaseClientRequestHandler
{

	@:overload
	override public function handleClientRequest(player:User,  params:ISFSObject):Void
	{
		//var requestId:String = params.getUtfString(SFSExtension.MULTIHANDLER_REQUEST_ID);
		//this.trace(ExtensionLogLevel.WARN, java.NativeArray.make(player.getName() + " send command:" + requestId));
		this.trace(ExtensionLogLevel.WARN, java.NativeArray.make(player.getName() + " send command:" + params.getDump()));
		//switch(requestId)
		//{
			//case test:
				//joinUser(player);
		//}
		joinUser(player);
	}
	
	function joinUser(user:User)
	{
		var rList = this.getParentExtension().getParentZone().getRoomList();
		var theRoom = null;
		var game = null;
		for (i in rList)
		{
			if (!i.isFull() && i.isActive())
				theRoom = i;
		}
		var ext = cast(this.getParentExtension(), MMOExtension);
		if (theRoom == null)
		{
			theRoom = makeANewRoom(user);
			game = new Game(theRoom.getId(), 0 ,ext);
			ext.games.put(theRoom.getId(), game);
		}else{
			log("Joining existing game :" + theRoom.getId());
			game = ext.games.get(theRoom.getId());
		}
		try{
			this.getParentExtension().getApi().joinRoom(user, theRoom);
			game.addPlayer(user);
		}catch (e:com.smartfoxserver.v2.exceptions.SFSJoinRoomException)
		{
			this.trace( ExtensionLogLevel.ERROR, java.NativeArray.make(e.toString()));
		}
	}
	
	function makeANewRoom(user:User)
	{
		var stamp = Std.string(Timer.stamp());
		var rs = new CreateRoomSettings();
		rs.setGame(true);
		rs.setDynamic(true);
		rs.setName("bac_" +user.getId()+"_"+ stamp.substr(stamp.length-3));
		rs.setMaxUsers(2);
		
		var room = this.getParentExtension().getApi().createRoom(this.getParentExtension().getParentZone(), rs, user);
		return room;
	}
	
	function log(obj:Dynamic){
		cast(this.getParentExtension(), MMOExtension).log(obj);
	}
	
}