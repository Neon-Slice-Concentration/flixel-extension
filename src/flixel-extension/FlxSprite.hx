package flixel.extension;

import flixel.FlxSprite as BaseFlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class FlxSprite extends BaseFlxSprite
{
    public var baseScaleX(default, null):Float = 1;
    public var baseScaleY(default, null):Float = 1;
    public var fadeTween(default, null):FlxTween;
    public var moveTween(default, null):FlxTween;
    public var scaleTween(default, null):FlxTween;

    public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:Dynamic)
    {
        super(X, Y, SimpleGraphic);
        baseScaleX = scale.x;
        baseScaleY = scale.y;
    }

    public function setScale(X:Float, ?Y:Float):FlxSprite
    {
        scale.set(X, Y == null ? X : Y);
        updateHitbox();
        return this;
    }

    public function rememberScale():FlxSprite
    {
        baseScaleX = scale.x;
        baseScaleY = scale.y;
        return this;
    }

    public function resetScale():FlxSprite
    {
        return setScale(baseScaleX, baseScaleY);
    }

    public function setPositionAndUpdate(X:Float, Y:Float):FlxSprite
    {
        setPosition(X, Y);
        return this;
    }

    public function setOpacity(Value:Float):FlxSprite
    {
        alpha = Math.max(0, Math.min(1, Value));
        return this;
    }

    public function setTint(Value:FlxColor):FlxSprite
    {
        color = Value;
        return this;
    }

    public function fadeTo(Target:Float, Duration:Float = 0.3, ?OnComplete:FlxSprite->Void):FlxSprite
    {
        if (fadeTween != null) fadeTween.cancel();
        var target = Math.max(0, Math.min(1, Target));
        if (Duration <= 0)
        {
            alpha = target;
            fadeTween = null;
            if (OnComplete != null) OnComplete(this);
            return this;
        }
        fadeTween = FlxTween.tween(this, {alpha: target}, Duration, {
            ease: FlxEase.quadOut,
            onComplete: function(_) {
                fadeTween = null;
                if (OnComplete != null) OnComplete(this);
            }
        });
        return this;
    }

    public function moveTo(X:Float, Y:Float, Duration:Float = 0.3, ?OnComplete:FlxSprite->Void):FlxSprite
    {
        if (moveTween != null) moveTween.cancel();
        if (Duration <= 0)
        {
            setPosition(X, Y);
            moveTween = null;
            if (OnComplete != null) OnComplete(this);
            return this;
        }
        moveTween = FlxTween.tween(this, {x: X, y: Y}, Duration, {
            ease: FlxEase.quadOut,
            onComplete: function(_) {
                moveTween = null;
                if (OnComplete != null) OnComplete(this);
            }
        });
        return this;
    }

    public function scaleTo(X:Float, Y:Float, Duration:Float = 0.3, ?OnComplete:FlxSprite->Void):FlxSprite
    {
        if (scaleTween != null) scaleTween.cancel();
        if (Duration <= 0)
        {
            setScale(X, Y);
            scaleTween = null;
            if (OnComplete != null) OnComplete(this);
            return this;
        }
        scaleTween = FlxTween.tween(scale, {x: X, y: Y}, Duration, {
            ease: FlxEase.quadOut,
            onComplete: function(_) {
                updateHitbox();
                scaleTween = null;
                if (OnComplete != null) OnComplete(this);
            }
        });
        return this;
    }

    public function cancelAnimations():FlxSprite
    {
        if (fadeTween != null) fadeTween.cancel();
        if (moveTween != null) moveTween.cancel();
        if (scaleTween != null) scaleTween.cancel();
        fadeTween = null;
        moveTween = null;
        scaleTween = null;
        return this;
    }

    override public function destroy():Void
    {
        cancelAnimations();
        super.destroy();
    }
}
