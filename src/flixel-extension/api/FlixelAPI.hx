package flixel.extension.api;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class FlixelAPI
{
    public static var screenWidth(get, never):Int;
    public static var screenHeight(get, never):Int;

    static function get_screenWidth():Int return FlxG.width;
    static function get_screenHeight():Int return FlxG.height;

    public static function createSprite(X:Float = 0, Y:Float = 0, Width:Int = 32, Height:Int = 32, Color:FlxColor = FlxColor.WHITE):FlxSprite
    {
        var sprite = new FlxSprite(X, Y);
        sprite.makeGraphic(Width > 0 ? Width : 1, Height > 0 ? Height : 1, Color);
        return sprite;
    }

    public static function addSprite(Sprite:FlxSprite, ?State:FlxState):FlxSprite
    {
        if (Sprite == null) return null;
        if (State != null) State.add(Sprite);
        else if (FlxG.state != null) FlxG.state.add(Sprite);
        return Sprite;
    }

    public static function centerSprite(Sprite:FlxSprite, Horizontal:Bool = true, Vertical:Bool = true):FlxSprite
    {
        if (Sprite == null) return null;
        if (Horizontal) Sprite.x = (FlxG.width - Sprite.width) * 0.5;
        if (Vertical) Sprite.y = (FlxG.height - Sprite.height) * 0.5;
        return Sprite;
    }

    public static function setSpriteScale(Sprite:FlxSprite, X:Float, ?Y:Float):FlxSprite
    {
        if (Sprite == null) return null;
        Sprite.scale.set(X, Y == null ? X : Y);
        Sprite.updateHitbox();
        return Sprite;
    }

    public static function setSpriteAlpha(Sprite:FlxSprite, Alpha:Float):FlxSprite
    {
        if (Sprite == null) return null;
        Sprite.alpha = clamp(Alpha, 0, 1);
        return Sprite;
    }

    public static function tweenSprite(Sprite:FlxSprite, X:Float, Y:Float, Duration:Float = 0.3):FlxTween
    {
        if (Sprite == null) return null;
        if (Duration <= 0)
        {
            Sprite.setPosition(X, Y);
            return null;
        }
        return FlxTween.tween(Sprite, {x: X, y: Y}, Duration, {ease: FlxEase.quadOut});
    }

    public static function fadeSprite(Sprite:FlxSprite, Alpha:Float, Duration:Float = 0.3):FlxTween
    {
        if (Sprite == null) return null;
        var target = clamp(Alpha, 0, 1);
        if (Duration <= 0)
        {
            Sprite.alpha = target;
            return null;
        }
        return FlxTween.tween(Sprite, {alpha: target}, Duration, {ease: FlxEase.quadOut});
    }

    public static function setCameraZoom(Zoom:Float, ?Camera:FlxCamera):Void
    {
        var camera = Camera != null ? Camera : FlxG.camera;
        if (camera != null) camera.zoom = Zoom;
    }

    public static function shakeCamera(Intensity:Float = 0.01, Duration:Float = 0.2, ?Camera:FlxCamera):Void
    {
        var camera = Camera != null ? Camera : FlxG.camera;
        if (camera != null) camera.shake(Intensity, Duration);
    }

    public static function flashCamera(Color:FlxColor = FlxColor.WHITE, Duration:Float = 0.3, ?Camera:FlxCamera):Void
    {
        var camera = Camera != null ? Camera : FlxG.camera;
        if (camera != null) camera.flash(Color, Duration);
    }

    public static function playSound(Asset:Dynamic, Volume:Float = 1):Void
    {
        if (Asset != null) FlxG.sound.play(Asset, clamp(Volume, 0, 1));
    }

    public static function playMusic(Asset:Dynamic, Volume:Float = 1, Loop:Bool = true):Void
    {
        if (Asset != null) FlxG.sound.playMusic(Asset, clamp(Volume, 0, 1), Loop);
    }

    public static function stopMusic():Void
    {
        if (FlxG.sound.music != null) FlxG.sound.music.stop();
    }

    public static function setVolume(Volume:Float):Void
    {
        FlxG.sound.volume = clamp(Volume, 0, 1);
    }

    public static inline function clamp(Value:Float, Min:Float, Max:Float):Float
    {
        return Math.max(Math.min(Min, Max), Math.min(Math.max(Min, Max), Value));
    }

    public static inline function lerp(From:Float, To:Float, Ratio:Float):Float
    {
        return From + (To - From) * Ratio;
    }

    public static inline function percent(Value:Float, Maximum:Float):Float
    {
        return Maximum == 0 ? 0 : (Value / Maximum) * 100;
    }

    public static function randomInt(Min:Int, Max:Int):Int
    {
        return FlxG.random.int(Min, Max);
    }

    public static function randomFloat(Min:Float, Max:Float):Float
    {
        return FlxG.random.float(Min, Max);
    }
}
