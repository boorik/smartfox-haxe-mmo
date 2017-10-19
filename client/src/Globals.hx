class Globals{
    public static var clientWidth:Int = 1184;
    public static var clientHeight:Int = 360;
    public static var gameViewWidthRatio:Float = 3/4;
    public static var gameViewHeightRatio:Float = 3/4;

    public static var envBitmapDatas:Map<String,flash.display.BitmapData>;

    static public function initSpriteSheets()
    {
        var rect = new flash.geom.Rectangle();
        var dest = new flash.geom.Point();

        envBitmapDatas = new Map<String,flash.display.BitmapData>();
        var envBmpData = openfl.Assets.getBitmapData("images/spritesheet_environment.png");
        var bush1 = new flash.display.BitmapData(36,39,true,0x00);
        rect.setTo(2,2,36,39);
        bush1.copyPixels(envBmpData,rect,dest);
        envBitmapDatas.set("bush1",bush1);

        var bush4 = new flash.display.BitmapData(46,67,true,0x00);
        rect.setTo(40,2,46,67);
        bush4.copyPixels(envBmpData,rect,dest);
        envBitmapDatas.set("bush4",bush4);

        var door = new flash.display.BitmapData(44,80,true,0x00);
        rect.setTo(88,2,44,80);
        door.copyPixels(envBmpData,rect,dest);
        envBitmapDatas.set("door",door);

        var tree2 = new flash.display.BitmapData(137,143,true,0x00);
        rect.setTo(134,2,137,143);
        tree2.copyPixels(envBmpData,rect,dest);
        envBitmapDatas.set("tree2",tree2);

        var tree3 = new flash.display.BitmapData(43,130,true,0x00);
        rect.setTo(273,2,43,130);
        tree3.copyPixels(envBmpData,rect,dest);
        envBitmapDatas.set("tree3",tree3);

        var tree4 = new flash.display.BitmapData(142,139,true,0x00);
        rect.setTo(318,2,142,139);
        tree4.copyPixels(envBmpData,rect,dest);
        envBitmapDatas.set("tree4",tree4);

    }
}