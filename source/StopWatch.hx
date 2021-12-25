package;

import flixel.FlxG;
import flixel.FlxBasic;

class StopWatch extends FlxBasic //used to keep track of time player spends in pause menu
{
    public var startTime:Float;

    public function new()
    {
        reset();

        super();
    }

    public function getTime() {
        return Sys.time() - startTime;
    }

    public function reset() {
        startTime = Sys.time();
    }
}