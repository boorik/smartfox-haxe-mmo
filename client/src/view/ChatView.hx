package view;

import flash.text.TextField;
import flash.events.KeyboardEvent;
class ChatView extends flash.display.Sprite
{
    public var input:TextField;
    public var output:TextField;
    public var onTextInput:String->Void;
    public function new()
    {
        super();

        graphics.beginFill(0xFFFFFF,1);
        graphics.drawRect(0,0,Globals.clientWidth*Globals.gameViewWidthRatio,Globals.clientHeight - Globals.clientHeight*Globals.gameViewHeightRatio);
        graphics.endFill();

        input = new TextField();
        input.type = flash.text.TextFieldType.INPUT;
        input.width = this.width;
        input.height = 20;
        input.border = true;
        input.y = height-20;
        input.addEventListener(KeyboardEvent.KEY_DOWN,onTextInputEvent);
        addChild(input);

        output = new TextField();
        output.width = this.width;
        output.height = this.height - input.height;
        output.border = true;
        output.wordWrap = true;
        output.multiline = true;
        
        addChild(output);


    }

    public function append(t:String)
    {
        output.appendText(t+"\n");
        trace("output.maxScrollV"+output.maxScrollV);
        trace("output.bottomScrollV"+output.bottomScrollV);
        //if(output.numLines > output.bottomScrollV)
        output.scrollV = output.numLines - output.bottomScrollV;
    }

    function onTextInputEvent(e:KeyboardEvent)
    {
        if(e.charCode == 13 && input.text != "")
        {
            onTextInput(input.text);
            input.text = "";
        }
    }
}