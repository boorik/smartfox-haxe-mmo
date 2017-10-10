package view;

class LevelSelectView extends flash.display.Sprite{
    static var pWidth = 500;
    static var pHeight = 220;
    var onMapSelected:String->Void;
    public function new(maps:Array<flash.display.Sprite>,cb:String->Void)
    {
        super();

        onMapSelected = cb;

        graphics.beginFill(0x008B8B,1);
        graphics.drawRoundRect(0,0,pWidth,pHeight,10);
        graphics.endFill();

        var initX = 33.;
        var initY = 10;
        for(m in maps)
        {
            m.scaleX = m.scaleY = 200/m.width;
            var s = new flash.display.Bitmap(new flash.display.BitmapData(Std.int(m.width),Std.int(m.height),false,0));
            s.name = m.name;
            s.bitmapData.draw(m);
            s.x = initX;
            s.y = (pHeight-s.height)/2;
            var cont = new flash.display.Sprite();
            cont.name = m.name;
            cont.addEventListener(flash.events.MouseEvent.CLICK,onMapClicked);
            cont.buttonMode = true;
            cont.addChild(s);
            addChild(cont);
            initX += s.width+33;
        }
    }

    function onMapClicked(e:flash.events.MouseEvent)
    {
        var m:flash.display.Sprite = cast e.target;
        onMapSelected(m.name);
    }

    public function destroy()
    {
        onMapSelected = null;
    }
}