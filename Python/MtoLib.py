"""
MtoLib module document.

Fast:2011/09/15
Last:2011/11/25    (c)Tsuyoshi.A(2.x)
Last:2022/07/01    (c)Tsuyoshi.A(3.x)
"""
import os
import math
import ConfigParser
from MtoFunc import *


#=====================================================================
# Vec3(x,y,z)
#=====================================================================
class Vec3(object):
    def __init__(self, x = 0.0, y = 0.0, z = 0.0):
        self.x = float(x)
        self.y = float(y)
        self.z = float(z)

    def __add__(self, v):
        return Vec3(self.x + v.x,
                    self.y + v.y,
                    self.z + v.z)

    def __sub__(self, v):
        return Vec3(self.x - v.x,
                    self.y - v.y,
                    self.z - v.y)

    def __iadd__(self, v):
        self.x += v.x
        self.y += v.y
        self.z += v.z
        return self

    def __isub__(self, v):
        self.x -= v.x
        self.y -= v.y
        self.z -= v.z
        return self

    def get(self):
        "XYZの取得"
        return self.x, self.y, self.z

    def Mul(self, num):
        """
        整数と乗算
        num: 乗算する値
        """
        self.x *= num
        self.y *= num
        self.z *= num

    def Div(self, num):
        """
        整数と除算
        num: 除算する値
        """
        self.x /= num
        self.y /= num
        self.z /= num

    def Length(self):
        "ベクトルの長さを取得"
        return math.sqrt(self.x * self.x +
                         self.y * self.y +
                         self.z * self.z)

    def LengthSq(self):
        "ベクトル長の２乗を取得"
        return (self.x * self.x +
                self.y * self.y +
                self.z * self.z)

    def Normalize(self):
        "単位ベクトル化"
        len = self.Length()
        if len > 0.0:
            len = 1.0 /len
        else:
            len = 0.0

        self.x *= len
        self.y *= len
        self.z *= len

    def Cross(v1, v2):
        """
        外積
        v1,v2: 入力ベクトル
        """
        return Vec3(v1.y * v2.z - v1.z * v2.y,
                    v1.z * v2.x - v1.x * v2.z,
                    v1.x * v2.y - v1.y * v2.x)

    def Dot(v1, v2):
        """
        内積
        v1,v2: 入力ベクトル
        """
        return (v1.x * v2.x + v1.y * v2.y + v1.z * v2.z)

    def Normal(v1, v2, v3):
        """
        法線ベクトルの取得
        v1,v2,v3: 三角形の頂点座標
        """
        a = v2 - v1
        b = v3 - v2
        v = Cross(a, b)
        v.Normalize()
        return v

    # スタティックメソッドの作成
    Cross = staticmethod(Cross)
    Dot = staticmethod(Dot)
    Normal = staticmethod(Normal)
    

#=====================================================================
# Vec4(x,y,z,w)
#=====================================================================
class Vec4(object):
    def __init__(self, x = 0.0, y = 0.0, z = 0.0, w = 1.0):
        self.x = float(x)
        self.y = float(y)
        self.z = float(z)
        self.w = float(w)

    def __add__(self, v):
        return Vec4(self.x + v.x,
                    self.y + v.y,
                    self.z + v.z,
                    self.w + v.w)

    def __sub__(self, v):
        return Vec4(self.x - v.x,
                    self.y - v.y,
                    self.z - v.y,
                    self.w - v.w)

    def __iadd__(self, v):
        self.x += v.x
        self.y += v.y
        self.z += v.z
        self.w += v.w
        return self

    def __isub__(self, v):
        self.x -= v.x
        self.y -= v.y
        self.z -= v.z
        self.w -= v.w
        return self

    def get(self):
        "XYZWの取得"
        return self.x, self.y, self.z, self.w

    def Mul(self, num):
        """
        整数と乗算
        num: 乗算する値
        """
        self.x *= num
        self.y *= num
        self.z *= num
        self.w *= num

    def Div(self, num):
        """
        整数と除算
        num: 除算する値
        """
        self.x /= num
        self.y /= num
        self.z /= num
        self.w /= num

    def Length(self):
        "ベクトルの長さを取得"
        return math.sqrt(self.x * self.x +
                         self.y * self.y +
                         self.z * self.z)

    def LengthSq(self):
        "ベクトル長の２乗を取得"
        return (self.x * self.x +
                self.y * self.y +
                self.z * self.z)

    def Normalize(self):
        "単位ベクトル化"
        len = self.Length()
        if len > 0.0:
            len = 1.0 /len
        else:
            len = 0.0

        self.x *= len
        self.y *= len
        self.z *= len

    def Cross(v1, v2):
        """
        外積
        v1,v2: 入力ベクトル
        """
        return Vec4(v1.y * v2.z - v1.z * v2.y,
                    v1.z * v2.x - v1.x * v2.z,
                    v1.x * v2.y - v1.y * v2.x,
                    0.0)

    def Dot(v1, v2):
        """
        内積
        v1,v2: 入力ベクトル
        """
        return (v1.x * v2.x + v1.y * v2.y + v1.z * v2.z)

    def Normal(v1, v2, v3):
        """
        法線ベクトルの取得
        v1,v2,v3: 三角形の頂点座標
        """
        a = v2 - v1
        b = v3 - v2
        v = Cross(a, b)
        v.Normalize()
        return v

    # スタティックメソッドの作成
    Cross = staticmethod(Cross)
    Dot = staticmethod(Dot)
    Normal = staticmethod(Normal)

