package data;

typedef DoidoOffsets = {
	var animOffsets:Array<Array<Dynamic>>;
	var globalOffset:Array<Float>;
	var cameraOffset:Array<Float>;
	var ratingsOffset:Array<Float>;
}

typedef PsychOffsets = {
	var animations:Array<PsychAnim>;
	var image:String;
	var scale:Float;

	var position:Array<Float>;
	var camera_position:Array<Float>;
	var rating_position:Null<Array<Float>>;

	var flip_x:Bool;
	var no_antialiasing:Bool;

	//var sing_duration:Float; WILL BE IMPLEMENTED EVENTUALLY! MAYBE!
}

typedef PsychAnim = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

enum abstract CharacterType(String) to String
{
	var DOIDO;
	var PSYCH;
}

class CharacterData
{
	public static function defaultOffsets():DoidoOffsets
	{
		return {
			animOffsets: [
				//["idle",0,0],
			],
			globalOffset: [0,0],
			cameraOffset: [0,0],
			ratingsOffset:[0,0]
		};
	}
}