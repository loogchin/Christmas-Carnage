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
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic;
import flixel.group.FlxGroup;

class EvilEye extends Character 
{
    public var info:Array<Dynamic> = [];
    public var timer:FlxTimer;
    public var clickSprite:ClickGraphic; //initializes in PlayState 
    public var cpuTimers = new FlxTimerManager();

    public function new(x,y,char,time, clicksneeded,cpu = false) {

        super(x, y, char, false);

        info = [
            time, 
            clicksneeded, 
            cpu, 
            0, //alpha and sound for playstate 3
            false, //isStunned
            0, //currentClicks
            false, //staring
            false, //cpu timers pause
            true, //do fade
            true //do animations
        ];

        timer = new FlxTimer().start(info[0], function(timer:FlxTimer) {
            if (!info[2])
                remove(true,false);
        });

        if (info[9])
            playAnim('come', true);

        specialAnim = true;

        animation.finishCallback = function (name:String) {
            if (name == 'come' && info[9]) {
                playAnim('idle', false);
                if (info[2]) {
                    cpuControl();
                }
            }
        }

        if (!info[2]) {
            FlxMouseEventManager.add(this, onMouseDown);
        }
    }

    function onMouseDown(Eye:EvilEye) {
        if (!info[2] && !info[4] && PlayState.cps < 20) {
            click(info[5] == info[1] - 1 ? true : false);
        }
            
    }

    public function remove(doKill = false, doAnimation = false) {
        if (!info[9]) return;
        info[9] = false;
        info[4] = true;
        info[6] = false;
        info[8] = false;
        info[3] = 0;

        if (doAnimation) {
            playAnim('run', true);

            if (clickSprite != null) 
                clickSprite.destroy();
            if (timer != null)
                timer.cancel();

            animation.finishCallback = function (name:String) {
                if(name == 'run') {
                    visible = false;
                    if (doKill)
                        PlayState.die = 'Eye';
                    if (PlayState.staresound != null)
                        PlayState.staresound.stop();
                    destroy();
                    return;
                }
		    }
        } else if (!doAnimation) {
            clickSprite.destroy();
            if (timer != null)
                timer.cancel();

            visible = false;
            if (doKill)
                PlayState.die = 'Eye';
            if (PlayState.staresound != null)
                PlayState.staresound.stop();
            destroy();
            return;
        }
    }

    public function click(lastClick:Bool = false):Void {
        if (!info[9]) return;
        if (!lastClick) {
            var j = FlxG.random.bool(50);
            if (j)
                FlxG.sound.play(Paths.sound('eyehit1'));
            else if (!j)
                FlxG.sound.play(Paths.sound('eyehit'));

            if (info[9])
                playAnim('click', true);
            info[5]++;
        } else if (lastClick) {
            info[4] = true;
            FlxG.sound.play(Paths.sound('eyescream'));
            remove(false, true);
        }

        animation.finishCallback = function (name:String) {
            if(name == 'click' && !lastClick && !info[6] && info[9]) {
                playAnim('idle',false);
            } else if (name == 'click' && !lastClick && info[6] && info[9]) {
                playAnim('stare',false);
            }
        }
    }

    public function pause():Void {
        if (!info[9]) return;
        if (timer != null)
            timer.active = false;
        if (info[2])
            info[7] = true;
        info[4] = true;
        stunned = true;
        clickSprite.pause();
        if (PlayState.staresound != null) // info 9
            PlayState.staresound.pause();
    }

    public function resume():Void {
        if (!info[9]) return;
        if (timer != null)
            timer.active = true;
        if (info[2])
            info[7] = false;
        info[4] = false;
        stunned = false;
        clickSprite.resume();
        if (PlayState.staresound != null)
            PlayState.staresound.resume();
    }

    public function cpuControl():Void {
        info[2] = true;
        info[4] = true;
        for (i in 0...Std.int(info[1] - info[5])) {
            new FlxTimer(cpuTimers).start(0.1 * i, function(timer:FlxTimer) {
                if (info[2])
                    click(info[5] == info[1] - 1 ? true : false);
            });
        }
    }
    
    override public function update(elapsed:Float):Void {
        if (!info[2] && timer != null) {
            info[6] = timer.progress >= 0.61 ? true : false;

            if (info[6] && timer != null && info[8]) {
                info[3] = timer.progress - 0.6;
            }    
        }

        if (timer.progress >= 0.6 && timer.progress <= 0.61 && info[9]) {
            playAnim('stare start', true);
            specialAnim = true;
            animation.finishCallback = function (name:String) {
                if (name == 'stare start') {
                    playAnim('stare',false);
                }
            }
        }

        if (!info[7])
            cpuTimers.update(elapsed);

        //fail safes for bot play shit 

        if (PlayState.cpuControlled && !info[2] && info[9])
            cpuControl();

        if (!PlayState.cpuControlled && info[2] && info[9]) {
            cpuTimers.forEach(function(tmr:FlxTimer) {
                tmr.cancel();
            });
            remove(false,true);
        }

        //Reef stun shit

        alpha = PlayState.healthBar.alpha;

        if (PlayState.doingreef && info[9]) {
            if (!info[2])
                info[4] = true;
        } else if (!PlayState.doingreef && info[9]) {
            if (!info[2])
                info[4] = false;
        }

        super.update(elapsed);
    }
}