package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.4.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<Character>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<Array<Dynamic>> = [//name/file,x,y
		['play',190,353],
		['freeplay',365,250],
		['options',534,457],
		#if ACHIEVEMENTS_ALLOWED
		['awards',603,222],
		#end
		['credits',850,385],
	];
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(0,280).loadGraphic(Paths.image('datree/MenuUI/Main Menu/menubg', 'shared'));
		bg.setGraphicSize(Std.int(bg.width * 0.26)); // 4k bg ong -lunar
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		menuItems = new FlxTypedGroup<Character>();

		for (i in 0...optionShit.length)
		{
			var menuItem:Character = new Character(optionShit[i][1],optionShit[i][2],optionShit[i][0]);
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;	
			menuItem.playAnim('idle');
			add(menuItem);
			remove(menuItem, true);
			insert(1, menuItem);
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Christmas Carnage v1.0", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		/*
		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end
		*/

		#if mobileC
		addVirtualPad(LEFT_RIGHT, A_B);
		#end
		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected][0] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:Character)
					{
						if (curSelected == spr.ID)
						{
								spr.playAnim('press');

								var daChoice:String = optionShit[curSelected][0];

								switch (daChoice)
								{
									case 'play':
										var songname = "Sleigh'd"; //song name -lunar
										var diff = 0; // diffaculty (0-easy 1-normal 2-hard)
										var daweek = 0; //0 - 5 (0-tutorial 1-week1 ect)
						
										var songLowercase:String = Paths.formatToSongPath(songname);
										var poop:String = Highscore.formatSong(songLowercase, diff);
										if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
											poop = songLowercase;
											diff = 1;
											trace('Couldnt find file');
										}
										trace(poop);
							
										PlayState.SONG = Song.loadFromJson(poop, songLowercase);
										PlayState.isStoryMode = false;
										PlayState.storyDifficulty = diff;
							
										PlayState.storyWeek = daweek;
										trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
										LoadingState.loadAndSwitchState(new PlayState());
							
										FlxG.sound.music.volume = 0;
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
								}
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:Character)
		{
			spr.playAnim('idle');

			if (spr.ID == curSelected) 
			{
				spr.playAnim('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
			}
		});
	}
}
