module asr.vector;

import std.math;

public struct VectorT(T, int N)
{
    public
    {
        union
        {
            T[N] v;

            struct
            {
                static if (N >= 2)
                {
                    T x;
                    T y;
                }
                static if (N >= 3)
                {
                    T z;
                }
                static if (N >= 4)
                {
                    T w;
                }
            }
        }
    }

    static if (N == 2)
    {
        public this(T x, T y)
        {
            this.x = x;
            this.y = y;
        }
    }
    static if (N == 3)
    {
        public this(T x, T y, T z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }
    }
    static if (N == 4)
    {
        public this(T x, T y, T z, T w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }
    }

    public this(T value)
    {
        for (int i = 0; i < N; i++)
        {
            this.v[i] = value;
        }
    }

    public T magnitude() const pure
    {
        return cast(T)sqrt(cast(float)this.magnitudeSquared);
    }

    public T magnitudeSquared() const pure
    {
        T total = 0;
        foreach (T component; v)
        {
            total += component * component;
        }
        return total;
    }

    public VectorT!(T, N) opBinary(string op)(VectorT!(T, N) that)
    {
        VectorT!(T, N) result;
        for (int i = 0; i < N; i++)
        {
            result.v[i] = mixin("this.v[i]" ~ op ~ "that.v[i]");
        }
        return result;
    }

    public VectorT!(T, N) opBinary(string op)(T scalar)
    {
        static if (op == "*" || op == "/")
        {
            VectorT!(T, N) result;
            for (int i = 0; i < N; i++)
            {
                result.v[i] = mixin("this.v[i]" ~ op ~ "scalar");
            }
            return result;
        }
        else
        {
            static assert(0, "Operator '" ~ op ~ "' is not supported.");
        }
    }

    public static T dot(VectorT!(T, N) a, VectorT!(T, N) b)
    {
        T result = 0;
        for (int i = 0; i < N; i++)
        {
            result += a.v[i] * b.v[i];
        }
        return result;
    }

    public static immutable VectorT!(T, N) zero = VectorT!(T, N)(0);
    public static immutable VectorT!(T, N) one = VectorT!(T, N)(1);
}


alias Point2 = VectorT!(int, 2);

alias Vector2 = VectorT!(float, 2);
alias Vector3 = VectorT!(float, 3);
alias Vector4 = VectorT!(float, 4);


public Point2 toPoint2(const ref Vector2 vector2)
{
    return Point2(cast(int)vector2.x, cast(int)vector2.y);
}

public Vector2 toVector2(const ref Point2 point2)
{
    return Vector2(point2.x, point2.y);
}


unittest
{
    assert(Vector2(3f, 4f).magnitudeSquared == 25f);
    assert(Vector2(3f, 4f).magnitude == 5f);
    assert(Vector2(3f, 4f) * 2f == Vector2(6f, 8f));
    assert(Vector2.dot(Vector2(1f, 2f), Vector2(3f, 4f)) == 11f);
}