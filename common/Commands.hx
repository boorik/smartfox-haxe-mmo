package;

/**
 * ...
 * @author vincent blanchet
 */
class Commands
{
	//user want to play
	static public inline var PLAY:String = "play";
	//inform user that he must wait another player
	static public inline var WAIT_OPPONENT:String = "wait_opponent";
	//game is created, send both user
	static public inline var GAME:String = "game";
	//send by client
	static public inline var READY:String = "ready";
	//send by client and dispatch to other client after check
	static public inline var MOVE:String = "move";
	//say which player turns
	static public inline var TURN:String = "turn";
	//end of game
	static public inline var END:String = "end";
	//error
	static public inline var ERROR:String="error";
	
}