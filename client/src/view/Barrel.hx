package view;

enum BarrelState
{
    OPEN;
    CLOSE;
}
class Barrel extends flash.display.Sprite
{
    var clickCB:Int->Void;
    var id:Int;
    var body:flash.display.Bitmap;

    public var state(default,set):BarrelState = OPEN;
    public function new(id:Int,isOpen:Bool,clickCB:Int->Void)
    {
        super();

        this.id = id;
        this.clickCB = clickCB;

        body = new flash.display.Bitmap(Globals.barrelBitmapDatas.get("openState"));
        if(!isOpen)
        {
            state = CLOSE;
            addEventListener(flash.events.MouseEvent.CLICK,onClick);
        }
        body.x = -18;
        body.y = -44;
        addChild(body);

    }

    function onClick(e:flash.events.MouseEvent)
    {
        e.stopPropagation();
        state = OPEN;
        clickCB(this.id);
        removeEventListener(flash.events.MouseEvent.CLICK,onClick);
    }

    function set_state(value:BarrelState):BarrelState
    {
        
        switch(value)
        {
            case OPEN :
                body.bitmapData = Globals.barrelBitmapDatas.get("openState");
            case CLOSE :
                body.bitmapData = Globals.barrelBitmapDatas.get("closeState");
        }
        return state = value;
    }

    public function destroy()
    {
        removeEventListener(flash.events.MouseEvent.CLICK,onClick);
        clickCB = null;
    }
}