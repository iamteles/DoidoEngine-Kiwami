package;

import data.Conductor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import openfl.system.Capabilities;
import data.Highscore;

enum SettingType
{
	CHECKMARK;
	SELECTOR;
}
class SaveData
{
	public static var data:Map<String, Dynamic> = [];
	public static var displaySettings:Map<String, Dynamic> = [
		"Ghost Tapping" => [
			true,
			CHECKMARK,
			"Makes you able to press keys freely without missing notes"
		],
		"Downscroll" => [
			false,
			CHECKMARK,
			"Makes the notes go down instead of up"
		],
		"Resolution" => [
			"1280x720",
			SELECTOR,
			"Change the game's resolution if it doesn't fit your monitor",
			["640x360","854x480","960x540","1024x576","1152x648","1280x720","1366x768","1600x900","1920x1080", "2560x1440", "3840x2160"],
		],
		"Antialiasing" => [
			true,
			CHECKMARK,
			"Disabling it might increase the fps at the cost of smoother sprites"
		],
		"Note Splashes" => [
			"ON",
			SELECTOR,
			"Whether a splash appear when you hit a note perfectly",
			["ON", "PLAYER ONLY", "OFF"],
		],
		"FPS Cap"	=> [
			"60",
			SELECTOR,
			"Ammount of frames being rendered in a second.",
			["30", "60", "120", "144"]
		],
		"FPS Counter" => [
			false,
			CHECKMARK,
			"Whether you want a counter showing your framerate and memory usage counter in the corner of the game",
		],	
		"Cutscenes" => [
			"ON",
			SELECTOR,
			"Decides if the song cutscenes should play",
			["ON", "FREEPLAY OFF", "OFF"],
		],
		'Flashing Lights' => [
			"ON",
			SELECTOR,
			"Whether to show flashing lights and colors",
			["ON", "REDUCED", "OFF"]
		],
		'Unfocus Freeze' => [
			true,
			CHECKMARK,
			"Freezes the game when unfocusing the window",
		],
		'Discord RPC' => [
			true,
			CHECKMARK,
			"Whether to use Discord's game activity.",
		],
		'Hitsounds' => [
			"OFF",
			SELECTOR,
			"Whether to play hitsounds whenever you hit a note",
			["OSU", "OFF"]
		],
		'Hitsound Volume' => [
			10,
			SELECTOR,
			"Only works when Hitsounds is enabled",
			[0, 10]
		],

		// this one doesnt actually appear at the regular options menu
		"Song Offset" => [
			0,
			SELECTOR,
			"no one is going to see this anyway whatever",
			[-100, 100],
		],
		"Input Offset" => [
			0,
			SELECTOR,
			"same xd",
			[-100, 100],
		],
		"Shaders" => [
			true,
			CHECKMARK,
			"Graphical effects that might cause performance drops."
		],
		"Low Quality" => [
			false,
			CHECKMARK,
			"Disables some objects to improve performance."
		],
	];
	
	public static var saveSettings:FlxSave = new FlxSave();
	public static var saveControls:FlxSave = new FlxSave();
	public static function init()
	{
		saveSettings.bind("settings",	Main.savePath); // use these for settings
		saveControls.bind("controls", 	Main.savePath); // controls :D
		FlxG.save.bind("save-data", 	Main.savePath); // these are for other stuff
		
		load();
		Controls.load();
		Highscore.load();
		subStates.editors.ChartAutoSaveSubState.load(); // uhhh
		updateWindowSize();
	}
	
	public static function load()
	{
		if(saveSettings.data.volume != null)
			FlxG.sound.volume = saveSettings.data.volume;
		if(saveSettings.data.muted != null)
			FlxG.sound.muted  = saveSettings.data.muted;

		if(saveSettings.data.settings == null || Lambda.count(displaySettings) != Lambda.count(saveSettings.data.settings))
		{
			for(key => values in displaySettings)
				data[key] = values[0];
			
			saveSettings.data.settings = data;
		}
		
		data = saveSettings.data.settings;
		save();
	}
	
	public static function save()
	{
		saveSettings.data.settings = data;
		saveSettings.flush();
		update();
	}

	public static function update()
	{
		Main.changeFramerate(data.get("FPS Cap"));
		
		if(Main.fpsCount != null)
			Main.fpsCount.visible = data.get("FPS Counter");

		FlxSprite.defaultAntialiasing = data.get("Antialiasing");

		FlxG.autoPause = data.get('Unfocus Freeze');

		Conductor.musicOffset = data.get('Song Offset');
		Conductor.inputOffset = data.get('Input Offset');
	}

	public static function updateWindowSize()
	{
		if(FlxG.fullscreen) return;
		var ws:Array<String> = data.get("Resolution").split("x");
        var windowSize:Array<Int> = [Std.parseInt(ws[0]),Std.parseInt(ws[1])];
        FlxG.stage.window.width = windowSize[0];
        FlxG.stage.window.height= windowSize[1];
		
		// centering the window
		FlxG.stage.window.x = Math.floor(Capabilities.screenResolutionX / 2 - windowSize[0] / 2);
		FlxG.stage.window.y = Math.floor(Capabilities.screenResolutionY / 2 - (windowSize[1] + 16) / 2);
	}
}