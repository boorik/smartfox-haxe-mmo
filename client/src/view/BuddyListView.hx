package view;
import com.smartfoxserver.v2.entities.Buddy;
import flash.events.MouseEvent;
import flash.display.Sprite;

class BuddyListView extends Sprite
{
	var label:openfl.text.TextField;
    public var onBuddyClicked:Buddy->Void;
	var container:Sprite;

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
        label.height = 25;
		addChild(label);
		
		container = new Sprite();
		container.y = label.height + 10;
		addChild(container);
		
		
    }

    public function update(ba:Array<Buddy>)
    {
        clean();
        var posY = 0.0;
        for(b in ba)
        {
            var bv = new BuddyView(b);
			bv.x = (this.width - bv.width) / 2;
            bv.y = posY;
            bv.addEventListener(MouseEvent.CLICK,onMouseClick);
            posY += bv.height+2;
            container.addChild(bv);
        }
    }

    public function clean()
    {
        while(container.numChildren > 1)
        {
            var bv:BuddyView = cast container.getChildAt(0);
            bv.removeEventListener(MouseEvent.CLICK,onMouseClick);
            container.removeChildAt(0);
        }
    }

    function onMouseClick(e:MouseEvent)
    {
        var bv:BuddyView = cast e.target;

        onBuddyClicked(bv.buddy);
    }


}