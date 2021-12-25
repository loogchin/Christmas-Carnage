package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic;

class GlobalMechanicHandler extends FlxTypedGroup<FlxBasic> //this shit was broken fuck it -lunar
{
    public var Eyes:FlxTypedGroup<EvilEye>;

    public function new():Void
    {
        super();

        Eyes = new FlxTypedGroup<EvilEye>();
		add(Eyes);
    }

    public function startMech(type:String, infoArray:Array<Dynamic>) {
        switch (type) {
            case 'Evil Eye':
                var Eye:EvilEye = new EvilEye(infoArray[0],infoArray[1],infoArray[2]);

                Eyes.add(Eye);
        }
    }

    public function pauseAllMechs():Void {
        if(Eyes != null) {
            Eyes.forEachAlive(function(spr:EvilEye){
                trace("pausing " + Eyes.countLiving() + " instances");
                spr.pause();
            }); 
        }
    }

    public function resumeAllMechs():Void {
        if(Eyes != null) {
            Eyes.forEachAlive(function(spr:EvilEye){
                trace("resume " + Eyes.countLiving() + " instances");
                spr.resume();
            }); 
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}