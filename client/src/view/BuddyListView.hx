package view;
import com.smartfoxserver.v2.entities.Buddy;
import flash.events.MouseEvent;

class BuddyListView extends flash.display.Sprite
{
    public var onBuddyClicked:Buddy->Void;

    public function new(){
        super();
    }

    public function update(ba:Array<Buddy>)
    {
        clean();
        var posY = 0.0;
        for(b in ba)
        {
            var bv = new BuddyView(b);
            bv.y = posY;
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