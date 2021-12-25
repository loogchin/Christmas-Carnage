package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxTimer;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;
import flixel.tweens.FlxEase;
import flixel.FlxState;

class ClickGraphic extends FlxSprite
{
    public var datimer:FlxTimer;

    public function new(x,y,time)
    {
        super(x,y);

        frames = Paths.getSparrowAtlas('datree/mechanics/FUCKINGCLICK');
        animation.addByPrefix('idle','CLICK!!', 24, true);
        animation.play('idle');

        setGraphicSize(Std.int(this.width * 0.76));

        updateHitbox();

        antialiasing = ClientPrefs.globalAntialiasing;

        datimer = new FlxTimer().start(time, function(datimer:FlxTimer) {
            destroy();
            return;
        });
    }

    public function pause():Void {
        if(datimer != null)
            datimer.active = false;
    }
    
    public function resume():Void {
        if(datimer != null)
            datimer.active = true;
    }
}