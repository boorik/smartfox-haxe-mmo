package view;
import com.smartfoxserver.v2.entities.Buddy;
import flash.text.TextField;
import flash.display.BitmapData;

class BuddyView extends flash.display.Sprite
{
    static var cartridgeBD:BitmapData;

    public var buddy:Buddy;
    var nameTF:TextField;
    static var WIDTH:Int = 100;
    static var HEIGHT:Int = 30;
    public function new(b:Buddy)
    {
        super();
        buddy = b;
        var bg = new flash.display.Bitmap(getCartridge());
        addChild(bg);
        nameTF = new TextField();
        nameTF.width = WIDTH;
        nameTF.height = HEIGHT;
        nameTF.mouseEnabled = false;
        nameTF.text = buddy.name;
        addChild(nameTF);
    }

    static function getCartridge():BitmapData
    {
        if(cartridgeBD == null)
        {
            cartridgeBD = new BitmapData(WIDTH,HEIGHT,false,0);
            cartridgeBD.fillRect(new flash.geom.Rectangle(0,0,WIDTH,HEIGHT),0x336699);
        }

        return cartridgeBD;

    }
}