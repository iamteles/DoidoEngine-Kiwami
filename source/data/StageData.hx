package data;

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef StageInfo =
{
	var objects:Array<StageObject>;
	var foreground:Array<StageObject>;

	var zoom:Null<Float>;
	var dadPos:Null<Array<Float>>;
	var bfPos:Null<Array<Float>>;
	var gfPos:Null<Array<Float>>;

    var dadCam:Null<Array<Float>>;
	var bfCam:Null<Array<Float>>;
	var gfCam:Null<Array<Float>>;

	var gfVersion:Null<String>;
}

typedef StageObject =
{
	var objName:Null<String>; // for the var/object name
	var path:Null<String>; // image path
	var animations:Null<Array<Animation>>;
	var position:Null<Array<Float>>; // position of the object
	var flipped:Null<Array<Bool>>; // whether object is flipped, on the X or Y axis
	var scale:Null<Float>; // sizer for object
	var alpha:Null<Float>; // alpha
	var scrollFactor:Null<Array<Int>>; // self explanatory i hope
	var lq:Null<Bool>; //whether an asset is loaded in Low Quality mode
}

typedef Animation =
{
	var name:String;
	var prefix:String;
	var framerate:Int;
	var looped:Bool;
}

class StageData {
    public static function load(path:String):StageInfo {
        var finalData:StageInfo = defaultStage();

        try {
            var jsonData:StageInfo = Paths.json(path);
            
            if(jsonData.dadPos.length > 2)
                jsonData.dadCam = [jsonData.dadPos[2], jsonData.dadPos[3]];

            if(jsonData.bfPos.length > 2)
                jsonData.bfCam = [jsonData.bfPos[2], jsonData.bfPos[3]];

            if(jsonData.gfPos.length > 2)
                jsonData.gfCam = [jsonData.gfPos[2], jsonData.gfPos[3]];

            trace('Loaded $path');

            finalData = jsonData;
        }
        catch(e){
            trace("ERROR: " + e);
        }

        return finalData;
    }

    inline public static function defaultStage():StageInfo
    {
        return
        {
            objects: [],
            foreground: [],
        
            zoom: 1,
            dadPos: [0,0],
            bfPos: [0,0],
            gfPos: [0,0],
            
            dadCam: [0,0],
            bfCam: [0,0],
            gfCam: [0,0],

            gfVersion: "placeholder",
        };
    }
}