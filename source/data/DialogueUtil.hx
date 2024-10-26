package data;

typedef DialogueData = {
	var pages:Array<DialoguePage>;
}
typedef DialoguePage = {
	// box
	var ?boxSkin:String;
	// character
	var ?char:String;
	var ?charAnim:String;
	// images
	var ?underlayAlpha:Float;
	var ?background:DialogueSprite;
	var ?foreground:DialogueSprite;
	// dialogue text
	var ?text:String;
	// text settings
	var ?textDelay:Float;
	var ?fontFamily:String;
	var ?fontScale:Float;
	var ?fontColor:Int;
	var ?fontBold:Bool;
	// text border
	var ?fontBorderType:String;
	var ?fontBorderColor:Int;
	var ?fontBorderSize:Float;
	// music and sound
	var ?music:String;
	var ?clickSfx:String;
	var ?scrollSfx:Array<String>;
}

typedef DialogueSprite = {
	var name:String;
	var image:String;
	// position
	var ?x:Float;
	var ?y:Float;
	var ?screenCenter:String;
	// other sprite stuff
	var ?scale:Float;
	var ?alpha:Float;
	// flipping
	var ?flipX:Bool;
	var ?flipY:Bool;
	// animation array
	var ?animations:Array<Animation>;
}

typedef Animation = {
	var name:String;
	var prefix:String;
	var framerate:Int;
	var looped:Bool;
}

class DialogueUtil
{
	public static function loadDialogue(song:String):DialogueData
	{
		switch(song)
		{
			//case 'senpai' | 'roses' | 'thorns':
			//	return loadCode(song);
			default:
				if(Paths.fileExists('images/dialogue/data/$song.json'))
					return cast Paths.json('images/dialogue/data/$song');
				else
					return defaultDialogue();
		};
	}

	inline public static function defaultDialogue():DialogueData
		return{pages: []};

	// Hardcoded DialogueData
	public static function loadCode(song:String):DialogueData
	{
		return switch(song)
		{
			default:
				defaultDialogue();
		}
	}
}