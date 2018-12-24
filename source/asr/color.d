module asr.color;

public struct ColorT(T)
{
    public T r;

    public T g;

    public T b;

    public T a;

    public this(T r, T g, T b)
    {
        static if (is(T == float))
        {
            this(r, g, b, 1.0f);
        }
        else
        {
            this(r, g, b, 255);
        }
    }

    public this(T r, T g, T b, T a)
    {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    static if (is(T == float))
    {
        private static immutable T max = 1;
    }
    else
    {
        private static immutable T max = 255;
    }
    private static immutable T min = 0;

    public static immutable ColorT!T clear = ColorT!T(min, min, min, min);
    public static immutable ColorT!T white = ColorT!T(max, max, max, max);
    public static immutable ColorT!T black = ColorT!T(min, min, min, max);
    public static immutable ColorT!T red = ColorT!T(max, min, min, max);
    public static immutable ColorT!T green = ColorT!T(min, max, min, max);
    public static immutable ColorT!T blue = ColorT!T(min, min, max, max);
    public static immutable ColorT!T cyan = ColorT!T(min, max, max, max);
    public static immutable ColorT!T magenta = ColorT!T(max, min, max, max);
    public static immutable ColorT!T yellow = ColorT!T(max, max, min, max);

    invariant
    {
        assert(min <= r && r <= max);
        assert(min <= g && g <= max);
        assert(min <= b && b <= max);
        assert(min <= a && a <= max);
    }
}


alias Color = ColorT!float;
alias Color32 = ColorT!ubyte;


public Color32 toColor32(const Color color)
{
    return Color32(cast(ubyte)(color.r * 255),
                   cast(ubyte)(color.g * 255),
                   cast(ubyte)(color.b * 255),
                   cast(ubyte)(color.a * 255));
}

public uint toUInt(const Color32 color)
{
    return (cast(uint)color.r << 24) | (cast(uint)color.g << 16) | (cast(uint)color.b << 8) | cast(uint)color.a;
}