package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flash.system.System;
import flixel.FlxCamera;
import flixel.util.FlxAxes;
import openfl.Lib;
import openfl.system.Capabilities;
import haxe.Exception;
import Std;

import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.FixedScaleMode;

using StringTools;

class BabyState extends FlxState //GOOG OOGOGOGOGOGOOGOOGOOGOGOOGOOOGOOGOOOGOOOGOOGOOGOOOGOOGOOGOGO -lunar
{

    var deez:FlxSprite;
    public var cameralmao:FlxCamera;

    public static var res:Array<Int> = [0,0,0,0];

    override public function create():Void
    {
        cameralmao = new FlxCamera();

        deez = new FlxSprite().loadGraphic(Paths.image('GOOGGOOOADAFGAGAAA')); 
        deez.screenCenter();
        deez.setGraphicSize(Std.int(deez.width * 2));
        deez.antialiasing = true;
		add(deez);
        
        FlxG.sound.play(Paths.sound('babycryloudasfuck'), 1);

        FlxG.camera.shake(0.05, 5, null, true, FlxAxes.XY);

        new FlxTimer().start(5, function(babybaby:FlxTimer)
			{
                Sys.exit(0);
			});
        super.create();

        res = [Lib.application.window.x,Lib.application.window.y,Lib.application.window.width,Lib.application.window.height];

        trace(res);
    }

    override public function update(elapsed:Float):Void
    {
        trace("WAAAAAAAAAAAA");

        Lib.application.window.move(res[0], res[1]);
        Lib.application.window.resize(res[2], res[3]);
        Lib.application.window.fullscreen = false;
        Lib.application.window.focus();

        super.update(elapsed);
    }
}