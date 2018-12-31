import asr;
import std.math;
import std.stdio;
import std.datetime.stopwatch;

public class DemoGame : Game
{
    private float _radius = 200f;

    private float _angularSpeed = PI / 4.0f;

    private Vector2 _from;

    private Vector2 _to;

    private float _currentTime;

    private Texture _texture;

    public this()
    {
        _currentTime = 0;
    }

    public override void load()
    {
        _texture = Texture.loadFromFile("res/image.png");
    }

    public override void unload()
    {

    }

    public override void update(float deltaTime)
    {
        _currentTime += deltaTime;

        auto x = _radius * cos(_currentTime * _angularSpeed);
        auto y = _radius * sin(_currentTime * _angularSpeed);
        auto center = Vector2(this.windowWidth / 2, this.windowHeight / 2);
        _from = center + Vector2(x, y);
        _to = center - Vector2(x, y);
    }

    public override void draw()
    {
        auto graphics = this.graphicsDevice;
        graphics.clear(Color.black);
        graphics.drawTextureRaw(_texture);
		graphics.drawLine(_from, _to, Color.white);
    }
}