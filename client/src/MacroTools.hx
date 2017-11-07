package;

class MacroTools{
    macro public static function getDefine(key:String)
    {
        var value = haxe.macro.Context.definedValue(key);
		return haxe.macro.Context.parse(value, haxe.macro.Context.currentPos());
    }
}