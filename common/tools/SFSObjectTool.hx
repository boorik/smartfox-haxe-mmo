package tools;
import com.smartfoxserver.v2.entities.data.SFSObject;
import haxe.Serializer;
import haxe.Unserializer;
/**
 * Serialization unserialization tools
 * @author vincent blanchet
 */
class SFSObjectTool
{
	public static function instanceToSFSObject(obj:Dynamic):SFSObject
	{
		if (obj == null)
			return null;
		
			
		var s = new Serializer();
		s.serialize(obj);
		var sfsObj = new SFSObject();
		sfsObj.putUtfString("obj", s.toString() );
		return sfsObj;
	}
	
	public static function sfsObjectToInstance(sfsObj:SFSObject):Dynamic
	{
		var res:Dynamic = null;
		if (sfsObj == null)
			return null;
			
		var so = sfsObj.getUtfString("obj");
		if (so == null)
			return null;
		try{
		var s = new Unserializer(so);
		
		res = s.unserialize();
		}catch (e:Dynamic){
			trace(e);
			trace(sfsObj.getDump());
			return null;
		}
		return res;
	}
}