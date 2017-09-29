package;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import Commands;
import Move;
import com.smartfoxserver.v2.entities.MMOItem;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.match.MatchExpression;
import com.smartfoxserver.v2.entities.match.NumberMatch;
import com.smartfoxserver.v2.entities.match.StringMatch;
import com.smartfoxserver.v2.requests.ExtensionRequest;
import com.smartfoxserver.v2.requests.LeaveRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import tools.SFSObjectTool;
/**
 * ...
 * @author vincent blanchet
 */
class SFSHandler
{
	var sfs:SmartFox;
	public var onMove:Move->Void;
	public var onTurn:Int->String->Void;
	public var onReady:StartState->Void;
	//public var onEnd:EndResult->Void;
	public var currentTurn:String;
	public var currentTurnId:Int;
	public var me(get, null):com.smartfoxserver.v2.entities.SFSUser;
	public var log:String->Void;
	
	public var onUserAdded:User->Void;
	public var onUserRemoved:User->Void;
	public var onItemAdded:MMOItem->Void;
	public var onItemRemoved:MMOItem->Void;
	
	public function new() 
	{

	}
	
	private function onUserExit(e:SFSEvent):Void 
	{
		#if html5
		log("User disconnected :" + e.user.name);
		#else
		log("User disconnected :" + e.params.user.name);
		#end
	}
	
	private function run(e:SFSEvent):Void 
	{
		trace("on extension response");
		var extParams:SFSObject = #if html5 e.params #else e.params.params #end;
		#if html5
		switch(e.cmd)
		#else
		switch(e.params.cmd)
		#end
		{
			case Commands.TURN :
				currentTurn = extParams.getUtfString("name");
				currentTurnId = extParams.getInt("id");
				trace('it is $currentTurn\'s turn');
				if (onTurn != null)
					onTurn(currentTurnId,currentTurn);
					
			case Commands.MOVE :
				var move : Move = SFSObjectTool.sfsObjectToInstance(extParams);

				if (onMove != null)
					onMove(move);
					
			case Commands.READY :
				//server is ready	
				log("Game started");
				var startState:StartState = SFSObjectTool.sfsObjectToInstance(extParams);

				if (onReady != null)
					onReady(startState);
		
			case Commands.WAIT_OPPONENT:
				log("Game joined, waiting for opponent...");
					
		}
	}
	
	public function move(move:Move):Void{
		sfs.send(new ExtensionRequest(Commands.MOVE, SFSObjectTool.instanceToSFSObject(move)));
	}
	/**
	 * player is ready
	 */
	public function ready():Void{
		sfs.send(new ExtensionRequest(Commands.READY));
	}
	
	public function leaveGame():Void
	{
		sfs.send(new LeaveRoomRequest());
	}
	
	public function play():Void
	{
		log("Sending request for joining a game.");
		sfs.send(new ExtensionRequest(Commands.PLAY));
	}
	
	
	public function connect():Void
	{
		#if !html5 
		var config:com.smartfoxserver.v2.util.ConfigData = new com.smartfoxserver.v2.util.ConfigData();
		config.httpPort = 8080;
		config.useBlueBox = false;
		#else
		var config:com.smartfoxserver.v2.SmartFox.ConfigObj = {host:"",port:0,useSSL:false,zone:"",debug:true};
		#end
		config.debug = true;
		config.host = "127.0.0.1";
		config.port = #if html5 8080 #else 9933 #end;
		config.zone = "MMOHaxe";
		#if html5
		sfs = new com.smartfoxserver.v2.SmartFox(config);
		sfs.logger.level = 0;
		#else
		sfs = new com.smartfoxserver.v2.SmartFox(true);
		#end
		sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
		sfs.addEventListener(SFSEvent.SOCKET_ERROR, onSocketError);
		sfs.addEventListener(SFSEvent.LOGIN_ERROR, onSocketError);
		sfs.addEventListener(SFSEvent.ROOM_CREATION_ERROR, onSocketError);
		sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onSocketError);
		sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit);
		sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, run);
		sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
		sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
		sfs.addEventListener(SFSEvent.PROXIMITY_LIST_UPDATE, onProximityListUpdate);
		trace("config:" + config);
		try{
		#if html5
		sfs.connect();
		#else
		sfs.connectWithConfig(config);
		#end
		}catch (e:Dynamic){
			trace(e+" " + haxe.CallStack.toString( haxe.CallStack.exceptionStack()));
		}
	}
	
	private function onProximityListUpdate(e:SFSEvent):Void 
	{
		
		log("Proximity update : " + e.parameters.room + " addedUsers:" + e.parameters.addedUsers + " removedUsers:" + e.parameters.removedUsers);
		if (e.parameters.addedUsers > 0 )
		{
			var au:Array<User> = e.parameters.addedUsers;
			for(u in au)
				onUserAdded(u);
		}
		if (e.parameters.removedUsers > 0 )
		{
			var ru:Array<User> = e.parameters.removedUsers;
			for(u in ru)
				onUserRemoved(u);
		}
	}
	
	private function onConnectionLost(e:SFSEvent):Void 
	{
		log("Connection lost!!!");
	}
	
	private function onLogin(e:SFSEvent):Void 
	{
		log("Logged.");
		sfs.send(new com.smartfoxserver.v2.requests.JoinRoomRequest("Main"));
		//play();
	}
	private function onRoomJoin(e:SFSEvent):Void 
	{
		log("Room joined:" + e.parameters.room.name);
	}
	private function onConnection(e:SFSEvent):Void 
	{
		log("pouet");
		log("onConnection = "+e.parameters.success);
		if (e.parameters.success)
		{
			log("Connected");
			sfs.addEventListener(SFSEvent.LOGIN, onLogin);
			#if html5
			sfs.send(new LoginRequest(null, null, null, "MMOHaxe"));
			#else
			sfs.send(new LoginRequest(null, null, "MMOHaxe"));
			#end
		}else{
			log("Not connected to internet");
		}
	}
	
	private function onSocketError(e:SFSEvent):Void 
	{
		log("socket error:" + e.params);
	}
	
	public function isAvailable():Bool
	{
		return sfs.isConnected;
	}
	
	public function destroy():Void
	{
		sfs.removeEventListener(SFSEvent.CONNECTION, onConnection);
		sfs.removeEventListener(SFSEvent.SOCKET_ERROR, onSocketError);
		sfs.removeEventListener(SFSEvent.LOGIN_ERROR, onSocketError);
		sfs.removeEventListener(SFSEvent.ROOM_CREATION_ERROR, onSocketError);
		sfs.removeEventListener(SFSEvent.ROOM_JOIN_ERROR, onSocketError);
		sfs.removeEventListener(SFSEvent.USER_EXIT_ROOM, onUserExit);
		sfs.removeEventListener(SFSEvent.EXTENSION_RESPONSE, run);
		sfs.removeEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
		sfs.removeEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
	}
	
	function get_me():com.smartfoxserver.v2.entities.SFSUser 
	{
		return cast sfs.mySelf;
	}
	
	
}