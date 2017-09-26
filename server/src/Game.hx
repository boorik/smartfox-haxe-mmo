package;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.SFSObject;
import Commands;
import haxe.Timer;
import tools.SFSObjectTool;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;
/**
 * ...
 * @author vincent blanchet
 */
class Game
{
	var id:Int;
	public var players:java.util.ArrayList<User>;
	var extension:MMOExtension;
	var currentTurn:User;
	var currentTurnId:Int;
	var destroyed:Bool;
	var readyNb:Int;
	var playerScores:Array<Int>;
	var mapId:Int;
	var notPlayedInARow:Array<Int>;
	public var started:Bool;
	static var mutex:Dynamic = {};
	public var nextTurnTime:Float;
	
	public function new(id:Int, mapId:Int,extension:MMOExtension) 
	{
		this.id = id;
		this.mapId = mapId;
		this.notPlayedInARow = [0,0];
		players = new java.util.ArrayList<User>();
		this.extension = extension;
		playerScores = [0,0];
		extension.trace( ExtensionLogLevel.ERROR, java.NativeArray.make("Game id:"+this.id+" created"));
	}
	
	public function isUserTurn(user:User):Bool
	{
		return user == currentTurn;
	}
	
	public function getUserPlayerId(usr:User):Int
	{
		for (i in 0...players.size())
		{
			if (players.get(i) == usr)
				return i;
		}
		return -1;//not found
	}
	
	public function addPlayer(p:User)
	{
		players.add(p);
		//start game
		if (players.size() == 2)
		{
			var startState:StartState = {players:[]};
			for(i in 0...players.size())
				startState.players.push({id:players.get(i).getId(),name:players.get(i).getName(), x:Std.random(700),y:Std.random(500)});
			extension.log("===== ServerReady ========");
			var obj:SFSObject = SFSObjectTool.instanceToSFSObject(startState);
			extension.log("PLAYER LIST:" + obj.getDump());

			extension.log("sending list...");
			extension.send(Commands.READY, obj, players);
		}else{
			extension.send(Commands.WAIT_OPPONENT,null, players);
		}
	}
	
	
	public function checkTurnTime()
	{
		if (Timer.stamp() >= nextTurnTime)
		{
			//changeTurn(true);
		}
	}
	
	//public function end(reason:EndReason)
	//{	
		//extension.send(Commands.END, SFSObjectTool.instanceToSFSObject({scores:playerScores, reason:reason}), players);
		//destroy();
	//}
	
	public function playerReady(user:User)
	{
		readyNb++;
		if (readyNb == players.size())
		{
			extension.log("===== Start game =====");
			started = true;
		}
	}
	
	public function removePlayer(p:User)
	{
		if (destroyed)
		{
			extension.trace(ExtensionLogLevel.WARN, java.NativeArray.make("===== Error this game is already destroyed ========"));
			return;
		}
		extension.trace(ExtensionLogLevel.WARN, java.NativeArray.make("user: " + p ));
		extension.trace(ExtensionLogLevel.WARN, java.NativeArray.make("try to remove user: " + p.getId() +" from game: " + this.id));
		
		//get player index
		var index:Int = -1;
		var found = false;
		for (pl in players)
		{
			index++;
			if (pl.getId() == p.getId())
			{
				found = true;
				break;
			}
		}
		if (found)
		{
			players.remove(index);
			extension.trace(ExtensionLogLevel.WARN, java.NativeArray.make("removing user: " + p.getId() +" from game: " + this.id));
		}
	}
	
	public function move(user:User,m:Move)
	{
		extension.send(Commands.MOVE, SFSObjectTool.instanceToSFSObject(m), players);
	}
	
	public function destroy()
	{
		extension.games.remove(this.id);
		extension.trace(ExtensionLogLevel.WARN, java.NativeArray.make("game : " + this.id +" destroyed"));
		started = false;
		extension = null;
		players = null;
		destroyed = true;
	}
	
	
	public static function removeUserFromGame(user:User, room:Room, extension:MMOExtension)
	{
		java.Lib.lock(mutex,{
			if (room != null)
				room.setActive(false);
			var game = extension.games.get(room.getId());
			if (game != null)
			{
				extension.trace(ExtensionLogLevel.WARN, java.NativeArray.make("Game "+game.id));
				game.removePlayer(user);
			}else{
				extension.trace(ExtensionLogLevel.WARN, java.NativeArray.make("Game :"+room.getId()+" not found"));
			}
		});
	}
}