package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import haxe.io.Path;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import openfl.display.BitmapData;
import openfl.utils.Assets as OpenFlAssets;
import openfl.display.BitmapData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup.FlxTypedGroup;
#if sys
import sys.FileSystem;
import sys.thread.Thread;
#end
import openfl.display.BitmapData;
import flixel.tweens.FlxTween;

class PreloadingState extends FlxState
{
    var funkay:FlxSprite;
	var loadBar:FlxSprite;

    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    var preloadAssets:Array<Array<String>> = [ //Path , Type -lunar
        ['datree/mechanics/arrow', 'image'],
		['datree/mechanics/bar', 'image'],
		['datree/mechanics/FUCKINGCLICK', 'image'],
        ['datree/mechanics/red mist', 'image'],
        ['datree/bg/cbg','image'],
        ['datree/bg/presents','image'],
		['datree/bg/bigger presents','image'],
        ['datree/bg/fire','image'],
        ['datree/bg/blubs','image'],
        ['datree/bg/deer','image'],
        ['characters/mtree','image'],
        ['characters/bfChristmas','image'],
        ['characters/gchair','image'],
		['datree/mechanics/gift','image'], 
        ['datree/mechanics/giftJUMPSCARE','image'], 
		['eyehit','sound'], 
		['eyehit1','sound'], 
		['eyeenter','sound'], 
		['eyegettingcloser','sound'], 
		['eyegettingclosserforpussys','sound'], 
		['eyescream','sound'], 
		['screamjumpscare','sound'], 
    ];

    var tobeDone:Int = 0;

    #if (haxe >= "4.0.0")
	public static var customImagesLoaded:Map<String, Bool> = new Map();
	#else
	public static var customImagesLoaded:Map<String, Bool> = new Map<String, Bool>();
	#end

    var done:Int = 0;

	var backgroundGroup:FlxTypedGroup<FlxSprite>;

    override public function create():Void
    {
		funkay = new FlxSprite().loadGraphic(Paths.image('funkay'));
		funkay.antialiasing = ClientPrefs.globalAntialiasing;
		funkay.screenCenter();
		add(funkay);

		loadBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 10, 0xffffffff);
		loadBar.screenCenter(X);
		loadBar.antialiasing = ClientPrefs.globalAntialiasing;
		loadBar.scale.x = 0;
		add(loadBar);

        tobeDone = preloadAssets.length;

        FlxG.game.focusLostFramerate = 60; //save shit -lunar
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;

		PlayerSettings.init();

        super.create();

        FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;

		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#end

		FlxG.autoPause = false; //TROLLAGE MOMENT 
		FlxG.camera.alpha = 0;

		FlxTween.tween(FlxG.camera, {alpha: 1}, 0.3, {
            onComplete: function(tween:FlxTween){
				if (ClientPrefs.preloader) {
					Thread.create(function(){
						preload();
					});
				} else {
					FlxTween.tween(FlxG.camera, {alpha: 0}, 0.1, {
						onComplete: function(tween:FlxTween){
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
            }
        });
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        loadBar.scale.x += 0.5 * ((done/tobeDone) - loadBar.scale.x);
    }

    function preload(){
        for(i in 0...preloadAssets.length) {
			FlxGraphic.defaultPersist = true;
            switch (preloadAssets[i][1]) {
                case 'image':
                    var savedGraphic:FlxGraphic = FlxG.bitmap.add(Paths.image(preloadAssets[i][0], 'shared'));
					trace('precaching images: ${preloadAssets[i][0]}');
				case 'sound':
					FlxG.sound.cache(Paths.sound(preloadAssets[i][0], 'shared'));
					trace('precaching sound: ${preloadAssets[i][0]}');
            }
			done++;
        }
		
		FlxTween.tween(FlxG.camera, {alpha: 0}, 0.1, {
            onComplete: function(tween:FlxTween){
				FlxG.switchState(new TitleState());
            }
        });
    }
}