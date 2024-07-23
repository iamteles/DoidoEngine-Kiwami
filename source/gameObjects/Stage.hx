package gameObjects;

import flixel.FlxG;
import flixel.FlxSprite;
//import flixel.addons.effects.FlxSkewedSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import states.PlayState;

class Stage extends FlxGroup
{
	public var curStage:String = "";

	// things to help your stage get better
	public var bfPos:FlxPoint  = new FlxPoint();
	public var dadPos:FlxPoint = new FlxPoint();
	public var gfPos:FlxPoint  = new FlxPoint();
	public var gfVersion:String = "";

	public var foreground:FlxGroup;

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
		
		/*
		*	makes changing stages easier by preloading
		*	a bunch of stages at the create function
		*	(remember to put the starting stage at the last spot of the array)
		*/
		for(i in stageList)
			reloadStage(i);
	}

	public function reloadStage(curStage:String = "")
	{
		this.clear();
		foreground.clear();
		
		gfPos.set(650, 550);
		dadPos.set(100,700);
		bfPos.set(850, 700);
		gfVersion = "placeholder";
		// setting gf to "placeholder" makes her invisible
		// consider your place held B)
		
		PlayState.camZoom = 1.0;
		
		this.curStage = curStage;
		switch(curStage)
		{
			default:
				this.curStage = "stage";
				PlayState.camZoom = 0.9;
				
				var bg = new FlxSprite(-600, -600).loadGraphic(Paths.image("backgrounds/stage/stageback"));
				bg.scrollFactor.set(0.6,0.6);
				add(bg);
				
				var front = new FlxSprite(-580, 440);
				front.loadGraphic(Paths.image("backgrounds/stage/stagefront"));
				add(front);

				if(!SaveData.data.get("Low Quality")){
					gfVersion = "gf";

					var curtains = new FlxSprite(-600, -400).loadGraphic(Paths.image("backgrounds/stage/stagecurtains"));
					curtains.scrollFactor.set(1.4,1.4);
					foreground.add(curtains);
				}
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
}