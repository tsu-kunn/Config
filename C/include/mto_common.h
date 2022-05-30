/*=============================================================================
 * 本当によく使うものだけを集めたヘッダー。
 * ツールやテストプログラムに使われることを想定。
 * C/C++対応（インライン非対応Cコンパイラは知らない）
 * C99/C11に対応(2021/03/08)
 * 
 * Fast 2010/08/24
 * Last 2021/03/13 Ver1.3.0                                      (c)Tsuyoshi.A
=============================================================================*/
#ifndef _MTO_COMMON_H_
#define _MTO_COMMON_H_

/*---------------------------------------------------------------------------
 * オプション
 *--------------------------------------------------------------------------*/
#if defined(__GNUC__) || defined(_MSC_VER) && (_MSC_VER >= 1400) // 1400:VC++2005
#define _USE_INT64				// int64を使用する？
#endif

#if defined(_MSC_VER)
#define _USE_CRTDBG				// メモリリークチェック(VC++限定)
#endif

#if _MSC_VER >= 1400
#pragma warning(disable:4201)	// anonymous unions warning
#pragma warning(disable:4996)	// 'function' が古い形式として宣言されました。
#pragma warning(disable:4127)	// 条件式が定数です。
#endif

#if defined(__GNUC__)
#define _USE_INLINE				// Cでinlineを使用する？
#endif

#if defined(_LANGUAGE_C_PLUS_PLUS) || defined(__cplusplus) || defined(c_plusplus)
#define _USE_CPP				// C++ソース
#endif

#ifdef __linux__
#define DIR_MODE false			// "/"でパス区切り
#else
#define DIR_MODE true			// "\\"でパス区切り
#endif


/*---------------------------------------------------------------------------
 * 全体で使用する標準ライブラリ
 *--------------------------------------------------------------------------*/
#ifndef NINC

#include <stdio.h>
#include <string.h>
#include <assert.h>

#if __STDC_VERSION__ >= 199901L	// C99以上
#include <stdint.h>
#include <stdbool.h>
#endif

#ifdef _USE_CPP
#include <iostream>
#include <cmath>
#include <vector>
#include <string>
#include <stdexcept>
#include <memory>
#else
#include <stdlib.h>
#include <math.h>
#endif //_USE_CPP

#endif //NINC


/*---------------------------------------------------------------------------
 * よく使用する列挙型
 *--------------------------------------------------------------------------*/
enum {X = 0, Y, Z, W};
enum {R = 0, G, B, A};

enum {
	off = 0,
	on
};

enum {
	eDIR_N = 0,
	eDIR_U,
	eDIR_D,
	eDIR_L,
	eDIR_R,
	eDIR_MAX
};

enum {
	eLP_ERROR = -1,
	eLP_BUSY  = 0,
	eLP_TRUE,
	eLP_CANCEL
};


/*---------------------------------------------------------------------------
 * よく使用するマクロ
 *--------------------------------------------------------------------------*/
#ifndef SAFE_FREE
#define SAFE_FREE(p)			{if(p) {free(p);p = NULL;}}
#endif
#ifndef SAFE_DELETE
#define SAFE_DELETE(p)			{if(p) {delete (p);(p) = NULL;}}
#endif
#ifndef SAFE_DELETES
#define SAFE_DELETES(p)			{if(p) {delete[] (p);(p) = NULL;}}
#endif
#ifndef SAFE_RELEASE
#define SAFE_RELEASE(p)			{if(p) {(p)->Release();(p) = NULL;}}
#endif

#ifndef BOUND
#define BOUND(n, a)				(((uint32)(n) + (a) - 1) & ~((a) - 1))
#endif

#ifndef NOTHING
#define NOTHING(arg)			((void)(arg))
#endif

#ifndef memcls
#define memcls(dest, size)		memset(dest, 0, size)
#endif

#ifndef TRUE
#define TRUE					(1)
#endif
#ifndef FALSE
#define FALSE					(0)
#endif

#define PI						3.141592654f
#define RAD						(PI / 180.0f)
#define DEG						(180.0f / PI)
#define DEGtoRAD(x)				((x) * RAD)
#define RADtoDEG(x)				((x) * DEG)

#define A_MAX					0xff
#define RGB_MAX					0xffffff
#define RGBA_MAX				0xffffffff

#define RGBA(r, g, b, a)		((r) | (g) << 8 | (b) << 16 | (a) << 24)
#define GPITCH(w, b)			((uint32)((float)(w) * ((float)(b) / 8.0f)))
#define SWAP(x, y)				((x) ^= (y) ^= (x) ^= (y))    //xとyの値を入れ替える

// デバッグ関係
#ifndef NDEBUG
#if defined(_WINDOWS_)
#define DBG_PRINT				OutputDebugString
#define DBG_ASSERT(x, s)		if (!(x)) {char str[256];memset(str,0,sizeof(str));sprintf(str, "%s(%d) : %s\n", __FILE__, __LINE__, s);OutputDebugString(str);assert(0);}
#define _ASSERT(x)				assert(x)
#else
#define DBG_PRINT				printf
#define DBG_ASSERT(x, s)		if (!(x)) {printf("%s(%d) : %s\n", __FILE__, __LINE__, s);assert(0);}
#define _ASSERT(x)				assert(x)
#endif // _WINDOWS_
#else
#define DBG_PRINT
#define DBG_ASSERT(x, s)
#define _ASSERT(x)
#endif // NDEBUG

// デバッグ用のメモリチェック
#if defined(_USE_CRTDBG) && !defined(NDEBUG)
#include <crtdbg.h>

#define SET_CRTDBG()			_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF  | \
											   _CRTDBG_LEAK_CHECK_DF | \
											   _CRTDBG_DELAY_FREE_MEM_DF)
#else
#define SET_CRTDBG()			
#endif

// 文字列比較の互換
#if defined(__GNUC__)
#define STRICMP(s0, s1)		strcasecmp(s0, s1)
#else
#define STRICMP(s0, s1)		stricmp(s0, s1)
#endif

// Windows互換
#ifndef _MAX_PATH
#define _MAX_PATH			(260)
#endif
#ifndef _MAX_FNAME
#define _MAX_FNAME			(128)
#endif
#ifndef _MAX_DIR
#define _MAX_DIR			(128)
#endif


/*---------------------------------------------------------------------------
 * 互換用変数
 *--------------------------------------------------------------------------*/
#ifdef _USE_INT64
typedef unsigned long long		uint64;
typedef signed long long		sint64;
#endif //_USE_INT64

typedef unsigned int			uint32;
typedef signed int				sint32;
typedef unsigned short			uint16;
typedef signed short			sint16;
typedef unsigned char			uint8;
typedef signed char				sint8;


/*---------------------------------------------------------------------------
 * 汎用構造体
 *--------------------------------------------------------------------------*/
typedef struct tagDVECTOR {
	sint16 vx;
	sint16 vy;
} DVECTOR;

typedef struct tagMultiPOINT {
	union {
		sint32 p[2];

		struct {
			sint32 x;
			sint32 y;
		};
		struct {
			sint32 w;
			sint32 h;
		};
		struct {
			sint32 u;
			sint32 v;
		};
		struct {
			sint32 p0;
			sint32 p1;
		};
	};
} MPOINT;

typedef struct tagRGBAQUAD {
	union {
		uint32 RGBA;

		struct {
			uint8 r;
			uint8 g;
			uint8 b;
			uint8 a;
		};
	};
} RGBAQUAD;

typedef struct tagRGBAQUADF { 
	float r;
	float g;
	float b;
	float a;
} RGBAQUADF;

#ifndef _WINDOWS_
/*
  MEMO:windows.hを使用しない場合の互換用です。
*/
#pragma pack(2)
typedef struct tagBITMAPFILEHEADER {
	uint16   bfType;
	uint32   bfSize;
	uint16   bfReserved1;
	uint16   bfReserved2;
	uint32   bfOffBits;
} BITMAPFILEHEADER;
#pragma pack()

typedef struct tagBITMAPINFOHEADER {
	uint32   biSize;
	uint32   biWidth;
	uint32   biHeight;
	uint16   biPlanes;
	uint16   biBitCount;
	uint32   biCompression;
	uint32   biSizeImage;
	uint32   biXPelsPerMeter;
	uint32   biYPelsPerMeter;
	uint32   biClrUsed;
	uint32   biClrImportant;
} BITMAPINFOHEADER;

typedef struct tagRGBQUAD { 
	uint8	rgbBlue;
	uint8	rgbGreen;
	uint8	rgbRed;
	uint8	pad;
} RGBQUAD;
#endif

typedef struct tagTriangleIndex {
	union {
		sint32 idx[3];

		struct {
			sint32	idx0;
			sint32	idx1;
			sint32	idx2;
		};
	};
} TriangleIndex;

typedef struct tagQuadIndex {
	union {
		sint32 idx[4];

		struct {
			sint32	idx0;
			sint32	idx1;
			sint32	idx2;
			sint32	idx3;
		};
	};
} QuadIndex;


/*---------------------------------------------------------------------------
 * 汎用inline関数
 *--------------------------------------------------------------------------*/
#if defined(_USE_CPP) || defined(_USE_INLINE)
#define MTOINLINE inline
#else
#define MTOINLINE _inline
#endif

/*=======================================================================
【機能】エンディアン変換
 =======================================================================*/
static MTOINLINE uint16 MtoBitReverse16(const uint16 num)
{
	return (uint16)(((num & 0xff00) >> 8) | ((num & 0x00ff) << 8));
}

static MTOINLINE uint32 MtoBitReverse32(const uint32 num)
{
	return (uint32)(((num & 0x000000ff) << 24) | ((num & 0x0000ff00) << 8) |
					((num & 0x00ff0000) >> 8) | ((num & 0xff000000) >> 24));
}

#ifdef _USE_INT64
static MTOINLINE uint64 MtoBitReverse64(const uint64 num)
{
	return (uint64)(((num & 0x00000000000000ffLL) << 56) | ((num & 0x000000000000ff00LL) << 40) |
					((num & 0x0000000000ff0000LL) << 24) | ((num & 0x00000000ff000000LL) <<  8) |
					((num & 0xff00000000000000LL) >> 56) | ((num & 0x00ff000000000000LL) >> 40) |
					((num & 0x0000ff0000000000LL) >> 24) | ((num & 0x000000ff00000000LL) >>  8));
}
#endif


/*=======================================================================
【機能】空白チェック
【引数】c：文字
 =======================================================================*/
static MTOINLINE sint32 MtoIsSpace(const char c)
{
	if ((0x09 <= c && c <= 0x0D) || c == 0x20) {
		return TRUE;
	}
	return FALSE;
}

/*=======================================================================
【機能】数字(0-9)チェック
【引数】c：文字
 =======================================================================*/
static MTOINLINE sint32 MtoIsNumber(const char c)
{
	if (0x30 <= c && c <= 0x39) {
		return TRUE;
	}
	return FALSE;
}


#ifndef NINC
/*=======================================================================
【機能】ファイルオープン
【引数】fp   ：ファイルポインタ
        fname：ファイル名
        opt  ：ファイルオプション
        fsize：ファイルサイズ保存先(不要の場合はNULL)
【戻値】ファイルオープンの成否
 =======================================================================*/
static MTOINLINE sint32 MtoFileOpen(FILE **fp, const char *fname, const char *opt, uint32 *fsize)
{
	uint32 size;

#ifndef NDEBUG
	_ASSERT(fp != NULL);
	_ASSERT(fname != NULL);
	_ASSERT(opt != NULL);
#endif

	// files open
	if ((*fp = fopen(fname, opt)) == NULL) {
		return FALSE;
	}

	// get file size
	fseek(*fp, 0, SEEK_END);
	size = ftell(*fp);
	fseek(*fp, 0, SEEK_SET);

	if (fsize != NULL) {
		*fsize = size;
	}
	
	return TRUE;
}

/*-------------------------------------------------------------------
【機能】ファイル読み込み
【引数】fname：ファイル名
        fsize：ファイルサイズ保存先(不要の場合はNULL)
【戻値】読み込んだファイルのポインタ
-------------------------------------------------------------------*/
static MTOINLINE void *MtoFileRead(const char *fname, uint32 *fsize)
{
	FILE *fp;
	void *mem;
	uint32 size;

	if ((fp = fopen(fname, "rb")) == NULL) {
#ifndef NDEBUG
		DBG_PRINT("file not found!\n");
#endif
		return NULL;
	}

	// get file size
	fseek(fp, 0, SEEK_END);
	size = ftell(fp);
	fseek(fp, 0, SEEK_SET);

	// read file to memory
	mem = malloc(size);

	if (mem == NULL) {
		fclose(fp);
		return NULL;
	}

	fread(mem, size, 1, fp);
	fclose(fp);

	if (fsize != NULL) {
		*fsize = size;
	}

	return mem;
}

/*=======================================================================
【機能】ファイルパスを取得
【引数】sname：保存先
        size ：保存先のバッファサイズ
        path ：フルパス
【備考】ASCIIコードに対応（日本語は非対応）
 =======================================================================*/
static MTOINLINE sint32 MtoGetFilePath(char *sname, const sint32 size, const char *path)
{
	// パスの最後を検索
	char *pathEnd = strrchr(path, '/'); // Linux

	if (pathEnd == NULL) {
		pathEnd = strrchr(path, '\\'); // Windows
		if (pathEnd == NULL) {
#ifndef NDEBUG
			DBG_PRINT("file path not found!\n");
#endif
			return 0;
		}
	}

	for (sint32 i = 0; i < (sint32)strlen(path); i++) {
		if (i >= size) break;
		if (path + i == pathEnd) {
			memcpy(sname, path, i);
			return i;
		}
	}

	return 0;
}

/*=======================================================================
【機能】ファイル名取得
【引数】sname：保存先
        size ：保存先のバッファサイズ
        path ：ファイルのパス
        flg  ：拡張子 0:なし 1:あり
【備考】ASCIIコードに対応（日本語は非対応）
 =======================================================================*/
static MTOINLINE sint32 MtoGetFileName(char *sname, const sint32 size, const char *path, const sint32 flg)
{
	int i, nlen, chk;

	i = 0;
	while (path[i] != '\0' && path[i] != 0x0d && path[i] != 0x0a) i++;
	nlen = i;
	chk  = off;

	for (; i >= 0; i--) {
		if (!chk) {
			if (!flg && path[i] == '.') {
				nlen = i;
				chk  = on;
			}

			if (flg && (path[i] == '\0' || path[i] == 0x0d || path[i] == 0x0a)) {
				nlen = i;
				chk  = on;
			}
		}

		if (path[i] == '\\' || path[i] == '/' || i == 0) {
			if (i == 0) {
				if (nlen < size) {
					memcpy(sname, path, nlen);
					return nlen;
				}
			} else {
				nlen -= (i + !flg);
				if (nlen < size) {
					memcpy(sname, &path[(i + 1)], nlen);
					return nlen;
				}
				break;
			}
		}
	}

	return 0;
}

/*=======================================================================
【機能】拡張子取得
【引数】sname：保存先
        size ：保存先のバッファサイズ
        path ：ファイルのパス
        flg  ：. 0:なし 1:あり
【備考】ASCIIコードに対応（日本語は非対応）
 =======================================================================*/
static MTOINLINE sint32 MtoGetExtension(char *sname, const sint32 size, const char *path, const sint32 flg)
{
	int i, nlen;

	i = 0;
	while (path[i] != '\0' && path[i] != 0x0d && path[i] != 0x0a) i++;
	nlen = i;

	for (; i >= 0; i--) {
		if (path[i] == '.') {
			if (!flg) i++;
			if ((nlen - i) >= size) return FALSE;

			memcpy(sname, &path[i], (nlen - i));
			break;
		}
		if (i == 0) { // 拡張子なし
			return FALSE;
		}
	}
	return TRUE;
}

/*=======================================================================
【機能】パスの作成
【引数】spath：保存先
        size ：保存先のバッファサイズ
        dir  ：ディレクトリのパス
        name ：ファイル名
        ext  ：拡張子（不要の場合はNULL）
		bWin ：false: Linux, true: Windows
【備考】ASCIIコードに対応（日本語は非対応）
        ディレクトリとファイル名の区切りと拡張子のピリオドは自動で設定
 =======================================================================*/
static MTOINLINE void MtoMakePath(char *spath, const sint32 size, const char *dir, const char *name, const char *ext, const bool bWin)
{
	if (bWin) {
		if (ext == NULL) {
			snprintf(spath, size, "%s\\%s", dir, name);
		} else {
			snprintf(spath, size, "%s\\%s.%s", dir, name, ext);
		}
	} else {
		if (ext == NULL) {
			snprintf(spath, size, "%s/%s", dir, name);
		} else {
			snprintf(spath, size, "%s/%s.%s", dir, name, ext);
		}
	}
}

#endif //NINC
#endif
