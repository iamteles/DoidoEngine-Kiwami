package gameObjects;

//import haxe.Json;
//import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import data.CharacterData;

using StringTools;

class Character extends FlxSprite
{
	public function new() {
		super();
	}

	public var curChar:String = "bf";
	public var isPlayer:Bool = false;

	public var holdTimer:Float = Math.NEGATIVE_INFINITY;
	public var holdLength:Float = 0.7;
	public var holdLoop:Int = 4;

	public var idleAnims:Array<String> = [];

	public var quickDancer:Bool = false;
	public var specialAnim:Int = 0;

	// warning, only uses this
	// if the current character doesnt have game over anims
	public var deathChar:String = "bf";

	public var globalOffset:FlxPoint = new FlxPoint();
	public var cameraOffset:FlxPoint = new FlxPoint();
	public var ratingsOffset:FlxPoint = new FlxPoint();
	private var scaleOffset:FlxPoint = new FlxPoint();
	
	var characterType:CharacterType = DOIDO;

	public function reloadChar(curChar:String = "bf"):Character
	{
		this.curChar = curChar;

		holdLoop = 4;
		holdLength = 0.7;
		idleAnims = ["idle"];

		quickDancer = false;

		flipX = flipY = false;
		scale.set(1,1);
		antialiasing = FlxSprite.defaultAntialiasing;
		isPixelSprite = false;
		deathChar = "bf";

		var storedPos:Array<Float> = [x, y];
		globalOffset.set();
		cameraOffset.set();
		ratingsOffset.set();

		animOffsets = []; // reset it

		if(Paths.fileExists('images/characters/_offsets/${curChar}-psych.json'))
			characterType = PSYCH;

		// what
		switch(curChar)
		{
			case "placeholder":
				frames = Paths.getSparrowAtlas("characters/placeholder");

				animation.addByPrefix('idle', 			'idle', 		24, false);
			case "bf":
				frames = Paths.getSparrowAtlas("characters/bf/BOYFRIEND");

				animation.addByPrefix('idle', 			'BF idle dance', 		24, false);
				animation.addByPrefix('singUP', 		'BF NOTE UP0', 			24, false);
				animation.addByPrefix('singLEFT', 		'BF NOTE LEFT0', 		24, false);
				animation.addByPrefix('singRIGHT', 		'BF NOTE RIGHT0', 		24, false);
				animation.addByPrefix('singDOWN', 		'BF NOTE DOWN0', 		24, false);
				animation.addByPrefix('singUPmiss', 	'BF NOTE UP MISS', 		24, false);
				animation.addByPrefix('singLEFTmiss', 	'BF NOTE LEFT MISS', 	24, false);
				animation.addByPrefix('singRIGHTmiss', 	'BF NOTE RIGHT MISS', 	24, false);
				animation.addByPrefix('singDOWNmiss', 	'BF NOTE DOWN MISS', 	24, false);
				animation.addByPrefix('hey', 			'BF HEY', 				24, false);

				animation.addByPrefix('firstDeath', 	"BF dies", 			24, false);
				animation.addByPrefix('deathLoop', 		"BF Dead Loop", 	24, true);
				animation.addByPrefix('deathConfirm', 	"BF Dead confirm", 	24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				flipX = true;

			case "gf":
				// GIRLFRIEND CODE
				frames = Paths.getSparrowAtlas('characters/gf/GF_assets');
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);

				animation.addByIndices('sad', 		'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight','GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				idleAnims = ["danceLeft", "danceRight"];
				quickDancer = true;
				flipX = isPlayer;

			case "dad":
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas("characters/dad/DADDY_DEAREST");
				animation.addByPrefix('idle', 		'Dad idle dance', 		24, false);
				animation.addByPrefix('singUP', 	'Dad Sing Note UP', 	24, false);
				animation.addByPrefix('singRIGHT', 	'Dad Sing Note RIGHT', 	24, false);
				animation.addByPrefix('singDOWN', 	'Dad Sing Note DOWN', 	24, false);
				animation.addByPrefix('singLEFT', 	'Dad Sing Note LEFT', 	24, false);

				animation.addByIndices('idle-loop', 	'Dad idle dance',  [11,12,13,14], "", 24, true);
				animation.addByIndices('singUP-loop', 	'Dad Sing Note UP',    [3,4,5,6], "", 24, true);
				animation.addByIndices('singRIGHT-loop','Dad Sing Note RIGHT', [3,4,5,6], "", 24, true);
				animation.addByIndices('singLEFT-loop', 'Dad Sing Note LEFT',  [3,4,5,6], "", 24, true);

			default:
				if(characterType != PSYCH)
					return reloadChar(isPlayer ? "bf" : "dad");
		}
		
		// offset gettin'
		switch(curChar)
		{
			default:
				try {
					switch(characterType) {
						case PSYCH:
							var charData:PsychOffsets = cast Paths.json('images/characters/_offsets/${curChar}-psych');

							frames = Paths.getSparrowAtlas(charData.image);

							if(charData.animations != null) {
								for (anim in charData.animations)
								{
									if(anim.indices != null && anim.indices.length > 0) {
										animation.addByIndices(anim.anim, anim.name, anim.indices, "", anim.fps, anim.loop);
									} else {
										animation.addByPrefix(anim.anim, anim.name, anim.fps, anim.loop);
									}
									if(anim.offsets != null && anim.offsets.length > 1) {
										addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
									}
								}
							}

							flipX = charData.flip_x;

							if(charData.scale != 1) {
								setGraphicSize(Std.int(width * charData.scale));
								updateHitbox();
							}

							globalOffset.set(charData.position[0], charData.position[1]);
							cameraOffset.set(charData.camera_position[0], charData.camera_position[1]);
							if(charData.rating_position != null)
								ratingsOffset.set(charData.rating_position[0], charData.rating_position[1]);
							else
								ratingsOffset.set(0, 0);

							if(animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null) {
								quickDancer = true;
								idleAnims = ['danceLeft', 'danceRight'];
							}
						default:
							var charData:DoidoOffsets = cast Paths.json('images/characters/_offsets/${curChar}');
					
							for(i in 0...charData.animOffsets.length)
							{
								var animData:Array<Dynamic> = charData.animOffsets[i];
								addOffset(animData[0], animData[1], animData[2]);
							}
							globalOffset.set(charData.globalOffset[0], charData.globalOffset[1]);
							cameraOffset.set(charData.cameraOffset[0], charData.cameraOffset[1]);
							ratingsOffset.set(charData.ratingsOffset[0], charData.ratingsOffset[1]);
					}

				} catch(e) {
					trace('$curChar offset error ' + e);
				}
		}
		
		playAnim(idleAnims[0]);

		updateHitbox();
		scaleOffset.set(offset.x, offset.y);

		if(isPlayer)
			flipX = !flipX;

		dance();

		setPosition(storedPos[0], storedPos[1]);

		return this;
	}

	private var curDance:Int = 0;

	public function dance(forced:Bool = false)
	{
		if(specialAnim > 0) return;

		switch(curChar)
		{
			default:
				playAnim(idleAnims[curDance]);
				curDance++;

				if (curDance >= idleAnims.length)
					curDance = 0;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		/* -- this fucking sucks lmfao
		if(animation.getByName(animation.curAnim.name + '-loop') != null)
			if(animation.curAnim.finished)
				playAnim(animation.curAnim.name + '-loop');
		*/
		
		if(specialAnim > 0 && animation.curAnim.finished && specialAnim < 3)
		{
			specialAnim = 0;
			dance();
		}
	}

	// animation handler
	public var animOffsets:Map<String, Array<Float>> = [];

	public function addOffset(animName:String, offX:Float = 0, offY:Float = 0):Void
		return animOffsets.set(animName, [offX, offY]);

	public function playAnim(animName:String, ?forced:Bool = false, ?reversed:Bool = false, ?frame:Int = 0)
	{
		if(!animation.exists(animName)) return;
		
		animation.play(animName, forced, reversed, frame);
		
		try
		{
			var daOffset = animOffsets.get(animName);
			offset.set(daOffset[0] * scale.x, daOffset[1] * scale.y);
		}
		catch(e)
			offset.set(0,0);

		// useful for pixel notes since their offsets are not 0, 0 by default
		offset.x += scaleOffset.x;
		offset.y += scaleOffset.y;
	}
}