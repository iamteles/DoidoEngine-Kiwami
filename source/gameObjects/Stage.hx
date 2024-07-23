package gameObjects;

import flixel.FlxG;
import flixel.FlxSprite;
//import flixel.addons.effects.FlxSkewedSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import states.PlayState;
import data.StageData;

class Stage extends FlxGroup
{
	public var curStage:String = "";

	// things to help your stage get better
	public var bfPos:FlxPoint  = new FlxPoint();
	public var bfCam:FlxPoint = new FlxPoint();

	public var dadPos:FlxPoint = new FlxPoint();
	public var dadCam:FlxPoint = new FlxPoint();

	public var gfPos:FlxPoint  = new FlxPoint();
	public var gfCam:FlxPoint = new FlxPoint();
	public var gfVersion:String = "";

	public var foreground:FlxGroup;
	public var objectMap:Map<String, FlxSprite> = new Map<String, FlxSprite>();
	public var stageData:StageInfo;

	public function new() {
		super();
		foreground = new FlxGroup();
	}

	public function reloadStageFromSong(song:String = "test"):Void
	{
		var stageList:Array<String> = [];
		
		stageList = switch(song)
		{
			default: ["stage"];
			
			//case "template": ["preload1", "preload2", "starting-stage"];
		};
		
		for(i in stageList)
			reloadStage(i);
	}

	public function reloadStage(curStage:String = "")
	{
		this.clear();
		foreground.clear();
		
		gfPos.set(0, 0);
		dadPos.set(0,0);
		bfPos.set(0, 0);

		gfCam.set(0, 0);
		dadCam.set(0,0);
		bfCam.set(0, 0);

		gfVersion = "placeholder";
		// setting gf to "placeholder" makes her invisible
		// consider your place held B)
		
		PlayState.camZoom = 1.0;
		
		this.curStage = curStage;
		switch(curStage)
		{
			/* //OLD STYLE STAGE!
			case "stage":
				this.curStage = "stage";
				PlayState.camZoom = 0.9;

				gfPos.set(300, 100);
				dadPos.set(100,100);
				bfPos.set(770, 450);
				
				var bg = new FlxSprite(-600, -200).loadGraphic(Paths.image("backgrounds/stage/stageback"));
				bg.scrollFactor.set(0.9,0.9);
				add(bg);
				
				var front = new FlxSprite(-650, 600);
				front.loadGraphic(Paths.image("backgrounds/stage/stagefront"));
				front.scrollFactor.set(0.9,0.9);
				add(front);

				if(!SaveData.data.get("Low Quality")){
					gfVersion = "gf";

					var curtains = new FlxSprite(-650, -500).loadGraphic(Paths.image("backgrounds/stage/stagecurtains"));
					curtains.scrollFactor.set(1.3,1.3);
					foreground.add(curtains);
				}
			*/
			default:
				if(DevOptions.stageJsons) {
					stageData = StageData.load('images/backgrounds/_offsets/' + curStage);
					loadFromJson();
				}
				else
					reloadStage("stage");
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	
	public function stepHit(curStep:Int = -1)
	{
		// put your song stuff here
		
		// beat hit
		if(curStep % 4 == 0)
		{
			
		}
	}

	function loadFromJson() {
		////trace('Finish load.');

		if(stageData.zoom != null) 
			PlayState.camZoom = stageData.zoom;

		if(stageData.dadPos != null) {
			dadPos.x = stageData.dadPos[0];
			dadPos.y = stageData.dadPos[1];
		}

		if(stageData.dadCam != null) {
			dadCam.x = stageData.dadCam[0];
			dadCam.y = stageData.dadPos[1];
		}

		if(stageData.bfPos != null) {
			bfPos.x = stageData.bfPos[0];
			bfPos.y = stageData.bfPos[1];
		}

		if(stageData.bfCam != null) {
			bfCam.x = stageData.bfCam[0];
			bfCam.y = stageData.bfCam[1];
		}

		if(stageData.gfPos != null) {
			gfPos.x = stageData.gfPos[0];
			gfPos.y = stageData.gfPos[1];
		}

		if(stageData.gfCam != null) {
			gfCam.x = stageData.gfCam[0];
			gfCam.y = stageData.gfCam[1];
		}

		if(stageData.gfVersion != null)
			gfVersion = stageData.gfVersion;

		if (stageData.objects != null)
		{
			for (object in stageData.objects)
			{
				if(object.lq || !SaveData.data.get("Low Quality")) {
					var newSpr:FlxSprite = new FlxSprite(object.position[0], object.position[1]);

					if(object.animations != null) {
						newSpr.frames = Paths.getSparrowAtlas(object.path);
						for (anim in object.animations) {
							newSpr.animation.addByPrefix(anim.name, anim.prefix, anim.framerate, anim.looped);
						}
						newSpr.animation.play('idle');
					}
					else {
						newSpr.loadGraphic(Paths.image(object.path));
					}
	
					if (object.scale != null)
					{
						newSpr.setGraphicSize(Std.int(newSpr.width * object.scale));
						newSpr.updateHitbox();
						////trace('Scaled.');
					}
	
					if (object.alpha != null)
						newSpr.alpha = object.alpha;
	
					if(object.scrollFactor != null) {
						newSpr.scrollFactor.set(object.scrollFactor[0], object.scrollFactor[1]);
					}
	
					if (object.flipped != null)
					{
						newSpr.flipX = object.flipped[0];
						newSpr.flipY = object.flipped[1];
					}
	
					objectMap.set(object.objName, newSpr);
					//trace('added ' + object.objName);
					add(newSpr);
				}
			}
		}

		if (stageData.foreground != null)
		{

			for (object in stageData.foreground)
			{
				if(object.lq || !SaveData.data.get("Low Quality")) {
					var newSpr:FlxSprite = new FlxSprite(object.position[0], object.position[1]);
					
					if(object.animations != null) {
						newSpr.frames = Paths.getSparrowAtlas(object.path);
						for (anim in object.animations) {
							newSpr.animation.addByPrefix(anim.name, anim.prefix, anim.framerate, anim.looped);
						}
						newSpr.animation.play('idle');
					}
					else {
						newSpr.loadGraphic(Paths.image(object.path));
					}

					if (object.scale != null)
					{
						newSpr.setGraphicSize(Std.int(newSpr.width * object.scale));
						newSpr.updateHitbox();
						////trace('Scaled.');
					}

					if (object.alpha != null)
						newSpr.alpha = object.alpha;

					if(object.scrollFactor != null) {
						newSpr.scrollFactor.set(object.scrollFactor[0], object.scrollFactor[1]);
					}

					if (object.flipped != null)
					{
						newSpr.flipX = object.flipped[0];
						newSpr.flipY = object.flipped[1];
					}

					objectMap.set(object.objName, newSpr);
					foreground.add(newSpr);
				}
			}
		}
	}
}