package;

import flixel.FlxState;
import flixel.FlxG;
#if windows
import Sys;
import sys.FileSystem;
#end

class BeeMoive extends MusicBeatState
{
    override public function create():Void
    {
        
        var content = [for (_ in 0...1000000) "BEE"].join(" ");

        var path = Paths.getUsersDesktop() + '/bee.txt';

        if (!sys.FileSystem.exists(path) || (sys.FileSystem.exists(path) && sys.io.File.getContent(path) == content))
            sys.io.File.saveContent(path, content);

        Sys.exit(0);

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}