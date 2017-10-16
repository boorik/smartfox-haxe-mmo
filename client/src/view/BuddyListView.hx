package view;
import com.smartfoxserver.v2.entities.Buddy;
import flash.events.MouseEvent;

class BuddyListView extends flash.display.Sprite
{
	var label:openfl.text.TextField;
    public var onBuddyClicked:Buddy->Void;

    public function new(){
        super();
		
		var w = Globals.clientWidth - Globals.clientWidth * Globals.gameViewWidthRatio;
		
		graphics.beginFill(0xC0C0C0);
		graphics.drawRect(0, 0, w, Globals.clientHeight);
		graphics.endFill();
		
		label = new openfl.text.TextField();
		label.defaultTextFormat = new openfl.text.TextFormat(null, 20, null, true);
		label.defaultTextFormat.align = openfl.text.TextFormatAlign.CENTER;
		label.text = "Buddies";
		label.x = (this.width - label.width) / 2;
		addChild(label);
    }

    public function update(ba:Array<Buddy>)
    {
        clean();
        var posY = 0.0;
        for(b in ba)
        {
            var bv = new BuddyView(b);
			bv.x = (this.width - bv.width) / 2;
            bv.y = label.height+10;
            bv.addEventListener(MouseEvent.CLICK,onMouseClick);
            posY += bv.height+2;
            addChild(bv);
        }
    }

    public function clean()
    {
        while(this.numChildren > 0)
        {
            var bv:BuddyView = cast getChildAt(0);
            bv.addEventListener(MouseEvent.CLICK,onMouseClick);
            removeChildAt(0);
        }
    }

    function onMouseClick(e:MouseEvent)
    {
        var bv:BuddyView = cast e.target;

        onBuddyClicked(bv.buddy);
    }


}