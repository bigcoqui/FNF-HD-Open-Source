package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxG;
import haxe.ds.Map;

using StringTools;

class Startup extends MusicBeatState
{
    public static var atlasFrames:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();
    var musicDone:Bool = false;
    var atlasDone:Bool = false;

    var loadingText:FlxText;

	override function create()
	{
        FlxG.mouse.visible = false;
        var loadingBG = new FlxSprite(0.0).loadGraphic(Paths.image('loadingscreen'));
        loadingBG.antialiasing = true;
        add(loadingBG);
        

        loadingText = new FlxText(5, FlxG.height - 30, 0, "Preloading Assets...", 24);
        loadingText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(loadingText);

        sys.thread.Thread.create(() -> {
            preloadAtlas();
        });
        sys.thread.Thread.create(() -> {
            preloadMusic();
        });
        super.create();
    }

    override function update(elapsed) 
    {
       if (atlasDone && musicDone)
        {
        loadingText.text = "Done!";
        FlxG.sound.play(Paths.sound('confirmMenu'));
        FlxG.switchState(new TitleState());
        }
        super.update(elapsed);
    }

    function preloadMusic():Void{
        var music = [];
        for (i in HSys.readDirectory("assets/songs"))
            {
                music.push(i);
            }

        for (i in music)
            {
                FlxG.sound.cache(Paths.inst(i));
                trace("cached " + i);
            }
        musicDone = true;
    }

    function preloadAtlas():Void{
    var atlasList = [];
    for (i in HSys.readDirectory('assets/images/TextureAtlas'))
        {
        atlasList.push(i);
		trace(i);
        }

    for (i in atlasList)
        {
        var bitmap = FlxGraphic.fromAssetKey(Paths.image('TextureAtlas/' + i + '/spritemap'));
        var testSprite = new FlxSprite(0,0,bitmap);
        bitmap.persist = true;
        bitmap.destroyOnNoUse = false;
        atlasFrames.set(i,bitmap);
        }
        atlasDone = true;
    }
}