package view;

class LoginView extends flash.display.Sprite
{
    static var pWidth = 300;
    static var pHeight = 100;

    var input:flash.text.TextField;
    var connectButton:flash.display.Sprite;
    var onClickCB:String->Void;

    public function new(defaultText:String,cb:String->Void)
    {
        super();

        onClickCB = cb;

        graphics.beginFill(0x008B8B,1);
        graphics.drawRoundRect(0,0,pWidth,pHeight,10);
        graphics.endFill();

        var format = new flash.text.TextFormat();
        format.align = flash.text.TextFormatAlign.CENTER;
        format.size = 20;

        input = new flash.text.TextField();
        input.width = pWidth*3/4;
        input.height = 24;
        input.defaultTextFormat = format;
        input.type = flash.text.TextFieldType.INPUT;
        input.border = true;
        input.background = true;
        input.backgroundColor = 0xFFFFFF;
        input.text = defaultText;
        input.x =(width - input.width)/2;
        input.y = 18;

        addChild(input);

        connectButton = new flash.display.Sprite();
        connectButton.graphics.beginFill(0x6495ED);
        connectButton.graphics.drawRoundRect(0,0,width*3/4,30,5);
        connectButton.graphics.endFill();
        connectButton.buttonMode = true;

        var label = new flash.text.TextField();
        label.height = 24;
        label.width = connectButton.width;
        label.defaultTextFormat = format;
        label.mouseEnabled = false;
        label.selectable = false;
        label.text = "Connect";
        //label.border = true;
        connectButton.addChild(label);
        
        connectButton.y = input.y + input.height+10;
        connectButton.x = (width - connectButton.width)/2;
        connectButton.addEventListener(flash.events.MouseEvent.CLICK,onConnectClick);

        addChild(connectButton);
    }

    function onConnectClick(e:flash.events.MouseEvent)
    {
        connectButton.removeEventListener(flash.events.MouseEvent.CLICK,onConnectClick);
        onClickCB(input.text);
    }
}