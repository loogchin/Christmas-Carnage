package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
//auto sizing -lunar
import flixel.graphics.FlxGraphic;
import flixel.FlxG;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	public var XOffset:Int = 0;
	public var YOffset:Int = 0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition((sprTracker.x + sprTracker.width + 10) + XOffset, (sprTracker.y - 30) + YOffset);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon

			var iconGraphic:FlxGraphic = FlxG.bitmap.add(Paths.image(name));
			loadGraphic(iconGraphic, true, Std.int(iconGraphic.width / 2), iconGraphic.height); 
			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			switch (this.char) 
			{
				case 'icon-tree' | 'tree':
					this.YOffset = -23;
					this.XOffset = -3;
				case 'icon-treeevil' | 'treeevil':
					this.YOffset = -42;
			}

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	public function getCharacter():String {
		return char;
	}
}
