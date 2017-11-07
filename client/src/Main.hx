package;

import openfl.display.Sprite;

/**
 * ...
 * @author vincent blanchet
 */
class Main extends Sprite 
{
	
	var clients:Array<Client>;
	
	public function new() 
	{
		super();

		#if noBuddyList
		Globals.gameViewWidthRatio = 1;
		#end

		Globals.initSpriteSheets();

		clients = [];
		var posY = 0.0;
		var numClient = 1;

		//enable multiple client in one app :
		//check the compilation define "numClient" if exists and set the given value
		#if (numClient > 1)
		numClient = MacroTools.getDefine("numClient");
		#end
		Globals.clientHeight = stage.stageHeight/numClient;
		for(i in 0...numClient)
		{
			var c = new Client();
			cast(c.view,Sprite).y = posY;
			addChild(cast(c.view,Sprite));
			posY += Globals.clientHeight;
		}

	}
}
