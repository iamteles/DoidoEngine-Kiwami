package states;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import data.ChartLoader;
import data.GameData.MusicBeatState;
import data.SongData.SwagSong;
import data.DialogueUtil;
import gameObjects.*;
import gameObjects.hud.*;
import gameObjects.hud.note.*;
import gameObjects.dialogue.Dialogue;

#if PRELOAD_SONG
import sys.thread.Mutex;
import sys.thread.Thread;
#end

/*
*	preloads all the stuff before going into playstate
*	i would advise you to put your custom preloads inside here!!
*/
class LoadingState extends MusicBeatState
{
	var threadActive:Bool = true;

	#if PRELOAD_SONG
	var mutex:Mutex;
	#end

	var behind:FlxGroup;
	var loadingTxt:FlxText;
	
	var loadPercent:Float = 0;
	var displayPercent:Float = 0;

	// technically this variable is used whenever the game cant load with the thread
	var gpuCaching:Bool = false;
	
	function addBehind(item:FlxBasic)
	{
		behind.add(item);
		behind.remove(item);
	}
	
	override function create()
	{
		super.create();
		behind = new FlxGroup();
		add(behind);

		gpuCaching = SaveData.data.get("GPU Caching");
		#if !PRELOAD_SONG
		gpuCaching = true;
		#end
		
		var color = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
		color.screenCenter();
		add(color);
		
		if(!gpuCaching) {
			loadingTxt = new FlxText(0,0,0,"Loading... (0%)");
			loadingTxt.setFormat(Main.gFont, 32, 0xFFFFFFFF, LEFT);
			loadingTxt.x += 10;
			loadingTxt.y = FlxG.height - loadingTxt.height - 5;
			add(loadingTxt);
		}
		else
			CoolUtil.playMusic();

		#if PRELOAD_SONG
		mutex = new Mutex();
		#else
		var black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
		#end

		if(gpuCaching) {
			preloadStuff();
			threadActive = false;
		}
		else {
			#if PRELOAD_SONG
			var preloadThread = Thread.create(function()
			{
				mutex.acquire();
				preloadStuff();
				threadActive = false;
				mutex.release();
			});
			#end
		}
	}
	
	var byeLol:Bool = false;
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(!threadActive && !byeLol)
		{
			byeLol = true;

			displayPercent = 100;
			Main.skipClearMemory = true;
			Main.switchState(new PlayState());
		}

		if(!gpuCaching) {
			if(threadActive) {
				displayPercent = Std.int(FlxMath.lerp(displayPercent, loadPercent*100, elapsed * 64));
			}
	
			loadingTxt.text = 'Loading... ($displayPercent%)';
		}
	}

	function preloadStuff()
	{
		var oldAnti:Bool = FlxSprite.defaultAntialiasing;
		FlxSprite.defaultAntialiasing = false;
		
		PlayState.resetStatics();
		var assetModifier = PlayState.assetModifier;
		var SONG = PlayState.SONG;
		var unspawnEvents = ChartLoader.getEvents(PlayState.EVENTS);
		
		Paths.preloadPlayStuff();
		Rating.preload(assetModifier);
		Paths.preloadGraphic('hud/base/healthBar');
		
		var stageBuild = new Stage();
		stageBuild.reloadStageFromSong(SONG.song);
		addBehind(stageBuild);

		var playerChars:Array<String> = [SONG.player1];
		var charList:Array<String> = [SONG.player1, SONG.player2, stageBuild.gfVersion];
		for(daEvent in unspawnEvents)
		{
			switch(daEvent.eventName)
			{
				case 'Change Character':
					charList.push(daEvent.value2);
					switch(daEvent.value1)
					{
						case 'bf'|'boyfriend': playerChars.push(daEvent.value2);
					}
				case 'Change Stage':
					stageBuild.reloadStage(daEvent.value1);
					addBehind(stageBuild);
					charList.push(stageBuild.gfVersion);
			}
		}
		trace('preloaded stage and hud');
		loadPercent = 0.2;
		for(i in charList)
		{
			var char = new Character(i, playerChars.contains(i));
			addBehind(char);

			if(char.isPlayer
			&& !charList.contains(char.deathChar))
			{
				var dead = new Character(char.deathChar, true);
				addBehind(dead);
			}
			
			//trace('preloaded char $i');
			
			if(i != stageBuild.gfVersion)
			{
				var icon = new HealthIcon();
				icon.setIcon(i, false);
				addBehind(icon);
			}
			loadPercent += (0.6 - 0.2) / charList.length;
		}
		
		trace('preloaded characters');
		loadPercent = 0.6;
		
		var songDiff:String = PlayState.songDiff;
		Paths.preloadSound(Paths.songPath('${SONG.song}/Inst', songDiff));
		if(SONG.needsVoices)
			Paths.preloadSound(Paths.songPath('${SONG.song}/Voices', songDiff));

		trace('preloaded music');
		loadPercent = 0.75;

		var dialData:DialogueData = DialogueUtil.loadDialogue(SONG.song);
		if(dialData.pages.length > 0) {
			var dial = new Dialogue();
			dial.load(dialData, true);
			addBehind(dial);
		}

		loadPercent = 0.85;
		
		// add custom preloads here!!
		switch(SONG.song)
		{
			default:
				trace('preloaded NOTHING extra lol');
		}
		loadPercent = 0.95;
		
		loadPercent = 1.0;
		trace('finished loading');
		FlxSprite.defaultAntialiasing = oldAnti;
	}
}