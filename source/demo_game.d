import asr;
import std.math;
import std.stdio;

public class DemoGame : Game
{
    private float _radius = 200f;

    private float _angularSpeed = PI / 4.0f;

    private Vector2 _from;

    private Vector2 _to;

    public this()
    {
    }

    public override void update(float deltaTime)
    {
        auto x = _radius * cos(deltaTime * _angularSpeed);
        auto y = _radius * sin(deltaTime * _angularSpeed);
        auto center = Vector2(this.windowWidth / 2, this.windowHeight / 2);
        _from = center + Vector2(x, y);
        _to = center - Vector2(x, y);
    }

    public override void draw()
    {
        auto device = this.graphicsDevice;
        device.clear(Color.black);
		device.drawLine(_from, _to, Color.white);
    }
}