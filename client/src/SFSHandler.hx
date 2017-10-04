package;
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import Commands;
import Move;
import com.smartfoxserver.v2.entities.MMOItem;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.requests.ExtensionRequest;
import com.smartfoxserver.v2.requests.LeaveRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.mmo.SetUserPositionRequest;
import com.smartfoxserver.v2.entities.data.Vec3D;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.entities.Buddy;
import com.smartfoxserver.v2.core.SFSBuddyEvent;
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
	public var onReady:Void->Void;
	//public var onEnd:EndResult->Void;
	public var currentTurn:String;
	public var currentTurnId:Int;
	public var me(get, null):com.smartfoxserver.v2.entities.SFSUser;
	public var log:String->Void;
	
	public var onUserAdded:User->Void;
	public var onUserRemoved:User->Void;
	public var onUserMoved:User->Float->Float->Void;
	public var onItemAdded:MMOItem->Void;
	public var onItemRemoved:MMOItem->Void;
	public var onBuddyList:Array<Buddy>->Void;
	
	static inline var USERVAR_X = "x";
	static inline var USERVAR_Y = "y";

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

		switch(e.parameters.cmd)
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
		config.zone = "SimpleMMOWorld";
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
		sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVariableUpdate);
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

	private function onUserVariableUpdate(e:SFSEvent):Void 
	{
		trace("===> onUserVariableUpdate");
		var changedVars:Array<String> = e.parameters.changedVars;
		var user:User = e.parameters.user;
		
		// Check if the user changed his position
		if (changedVars.indexOf(USERVAR_X) != -1 || changedVars.indexOf(USERVAR_Y) != -1)
		{
			var px = user.getVariable(USERVAR_X).getDoubleValue();
			var py = user.getVariable(USERVAR_Y).getDoubleValue();

			// Move the user avatar
			onUserMoved(user,px,py);
		}
	}
	
	private function onProximityListUpdate(e:SFSEvent):Void 
	{
		
		log("Proximity update : " + e.parameters.room + " addedUsers:" + e.parameters.addedUsers + " removedUsers:" + e.parameters.removedUsers);
		var au:Array<User> = e.parameters.addedUsers;
		log("added:"+au);
		if (au.length > 0 )
		{
			log("toto");
			for(u in au)
				onUserAdded(u);
		}
		var ru:Array<User> = e.parameters.removedUsers;
		if (ru.length > 0 )
		{
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
		log("Logged as "+me.name);
		sfs.send(new com.smartfoxserver.v2.requests.JoinRoomRequest("The Map"));
		//play();
	}
	private function onRoomJoin(e:SFSEvent):Void 
	{
		log("Room joined:" + e.parameters.room.name);
		sfs.send(new SetUserPositionRequest(new Vec3D(10,10,0)));
		onReady();

	}
	private function onConnection(e:SFSEvent):Void 
	{
		if (e.parameters.success)
		{
			log("Connected");
			sfs.addEventListener(SFSEvent.LOGIN, onLogin);
			#if html5
			sfs.send(new LoginRequest(null, null, null, "SimpleMMOWorld"));
			#else
			sfs.send(new LoginRequest(null, null, "SimpleMMOWorld"));
			#end
		}else{
			log("Not connected to internet");
		}
	}
	
	private function onSocketError(e:SFSEvent):Void 
	{
		log("socket error:" + e.parameters);
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

	public function sendPosition(x:Float,y:Float)
	{
		
		var userVars:Array<UserVariable> = [];
		userVars.push(new SFSUserVariable(USERVAR_X, x));
		userVars.push(new SFSUserVariable(USERVAR_Y, y));

		sfs.send(new com.smartfoxserver.v2.requests.SetUserVariablesRequest(userVars));
		sfs.send(new SetUserPositionRequest(new Vec3D(Math.fround(x),Math.fround(y),0)));
	}

	public function initBuddyList()
	{
		sfs.addEventListener(SFSBuddyEvent.BUDDY_ADD,onBuddyListInitialized);
		sfs.addEventListener(SFSBuddyEvent.BUDDY_LIST_INIT,onBuddyListInitialized);
		sfs.send(new com.smartfoxserver.v2.requests.buddylist.InitBuddyListRequest());
	}

	function onBuddyListInitialized(e:SFSBuddyEvent)
	{
		var buddies:Array<Buddy> = sfs.buddyManager.buddylist;

		onBuddyList(buddies);

	}

	public function addBuddy(u:User)
	{
		sfs.send(new com.smartfoxserver.v2.requests.buddylist.AddBuddyRequest(u.name));
	}
	
	
}