package view;
import openfl.Lib;
import openfl.text.TextField;

/**
 * ...
 * @author vincent blanchet
 */
class MainScreen extends openfl.display.Sprite
{
	public var logTextField:TextField;
	public function new() 
	{
		super();
		
		logTextField = new TextField();
		logTextField.width = Lib.current.stage.stageWidth;
		addChild(logTextField);

		graphics.beginFill(Std.random(0xFFFFFF));
		graphics.drawRect(0, 0, 600, 200);
		graphics.endFill();
	}
	
	public function log(value:String)
	{
		logTextField.appendText(value+"\n");
		logTextField.scrollV = logTextField.maxScrollV;
	}
	
}