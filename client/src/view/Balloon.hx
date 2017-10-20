package view;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;

class Balloon extends flash.display.Sprite
{
    var top:Bitmap;
    var middle:Bitmap;
    var bottom:Bitmap;
    var container:Sprite;
    var textTF:TextField;

    public function new()
    {
        super();

        container = new Sprite();

        top = new Bitmap(Globals.balloonBitmapDatas.get("top"));
        middle = new Bitmap(Globals.balloonBitmapDatas.get("middle"));
        bottom = new Bitmap(Globals.balloonBitmapDatas.get("bottom"));
        container.addChild(top);
        middle.y = top.height;
        container.addChild(middle);
        container.addChild(bottom);
        addChild(container);

        textTF = new TextField();
        textTF.x = 5;
        textTF.y = middle.y;
        textTF.width = 90;
        textTF.wordWrap = true;
        textTF.autoSize = "left";
        container.x = -45;
        container.addChild(textTF);
    }

    public function updateText(txt:String)
    {
        textTF.text = txt;
        middle.scaleY = textTF.getBounds(this).height/10;
        bottom.y = textTF.getBounds(this).height+10;
        container.y = -container.height;
    }

}