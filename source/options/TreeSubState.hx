package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class TreeSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Christmas Tree';
		rpcTitle = 'Christmas Tree'; //for Discord Rich Presence

		var option:Option = new Option('Tinnitus', //Name
		'Turns off dumbass ringing sound', //Description
		'Ringing', //Save data variable name
		'bool', //Variable type
		true); //Default value
		addOption(option);

		var option:Option = new Option('Fetus Mode', //Name
		'Turns off all mechanics.', //Description
		'fetus', //Save data variable name
		'bool', //Variable type
		false); //Default value
		addOption(option);

		var option:Option = new Option('Preloader', //Name
		'If turned on preloader will preload assets.\nThis will use memory but will cause less lag when assets are loaded\n(Needs a restart to apply changes)', //Description
		'preloader', //Save data variable name
		'bool', //Variable type
		true); //Default value
		addOption(option);

		var option:Option = new Option('HaxeFlixel Cursor', //Name
		'If turned on HaxeFlixel Cursor will be used.', //Description
		'hfcursor', //Save data variable name
		'bool', //Variable type
		true); //Default value
		addOption(option);

		super();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end
}