package;
import java.lang.Thread;

/**
 * thread to check every games turn time
 * @author vincent blanchet
 */
class TimeController extends Thread
{
	var extension:MMOExtension;
	public var halt:Bool;
	public function new(ext:MMOExtension) 
	{
		super();
		extension = ext;
	}
	
	@:overload override public function run()
	{
		while (!halt)
		{
			try{
				var e = extension.games.elements();
				while(e.hasMoreElements())
				{
					var g:Game = e.nextElement();
					if (g.started)
					{
						g.checkTurnTime();
					}
				}
			}catch (e:Dynamic){
				extension.log("Error while looping for time : " + e);
			}
			try
			{ 
				Thread.sleep(200); 
			}
			catch(e:Dynamic)
			{
				// Halt this thread
				extension.log("Haxe extension was halted");
			}	
		}
	}
	
}