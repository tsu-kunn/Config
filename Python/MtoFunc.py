"""
MtoFunc module document.

Fast:2011/10/11
Last:2011/11/25    (c)Tsuyoshi.A(2.x)
Last:2020/02/20    (c)Tsuyoshi.A(3.x)
"""
import os
import sys
import time
import fnmatch
import subprocess
import shutil
import codecs


#=====================================================================
# Debug
#=====================================================================
__clockStart = 0
def clockStart(msg = "clock start"):
    """
    プロセッサ時間を利用して処理時間の計測を開始します
    msg: 開始前に表示させたいメッセージ
    """
    global __clockStart
    print(msg)
    __clockStart = time.clock()

def clockEnd(msg = ""):
    """
    プロセッサ時間を利用しての処理時間計測を終了します
    msg: 終了後に表示させたいメッセージ
    """
    print("clock time: " + str(time.clock() - __clockStart))
    if msg != "": print(msg)


#=====================================================================
# find
#=====================================================================
""" find options """
FIND_OPT_NONE = 0 # なし
FIND_OPT_DIR  = 1 # ディレクトリ検索
FIND_OPT_FILE = 2 # ファイル検索
FIND_OPT_REFL = 4 # サブディレクトリも検索
FIND_OPT_RDIR  = (FIND_OPT_DIR | FIND_OPT_REFL)
FIND_OPT_RFILE = (FIND_OPT_FILE | FIND_OPT_REFL)
FIND_OPT_DFR   = (FIND_OPT_DIR | FIND_OPT_FILE | FIND_OPT_REFL)

def find(path, opt = FIND_OPT_NONE, name = None):
    """
    ファイル検索(ワイルドカード対応)
    path: 検索パス
    opt : 検索オプション(FIND_OPT_xxxのOR)
    name: シェル形式のワイルドカードを使用する場合に指定
    戻値: パスリスト
    備考: name ex)
          find(\"./\", name=\"*/*.png\")
    """
    if path == "":
        raise UserWarning("NotFindPath")

    # パスを分割
    if name == None:
        path, name = os.path.split(path)

    if name == "":
        raise UserWarning("NotFindName")

    try:
        findList = []
        for root, dirs, files in os.walk(path):
            tmpList = []

            if opt & FIND_OPT_DIR:
                tmpList += fnmatch.filter(dirs, name)

            if opt & FIND_OPT_FILE:
                tmpList += fnmatch.filter(files, name)

            #for i in tmpList:
            #    i = root + "/" + i
            #    findList.append(i.replace("\\", "/")) # Unix form
            findList += [(root + "/" + i).replace("\\", "/") for i in tmpList]

            # 再帰検索？
            if opt & FIND_OPT_REFL == False:
                break
    except GeneratorExit:
        # ジェネレータのclose()が呼ばれたときの例外は無視
        pass

    return findList


def findEx(path, opt = FIND_OPT_NONE, name = None):
    """
    ファイル検索(ワイルドカード対応)
    path: 検索パス
    opt : FIND_OPT_NONE/FIND_OPT_REFL
    name: シェル形式のワイルドカードを使用する場合に指定
    戻値: dirList, fileDic(fileList = fileDic[dirList[i]])
          ディレクトリパスとそれに対応するファイルリスト
    """
    if path == "":
        raise UserWarning("NotFindPath")

    # パスを分割
    if name == None:
        path, name = os.path.split(path)

    if name == "":
        raise UserWarning("NotFindName")

    dirList = []
    fileDic = {}
    for root, dirs, files in os.walk(path):
        root = root.replace("\\", "/") # Unix form

        #for i in fnmatch.filter(dirs, name):
        #    i = root + "/" + i
        #    dirList.append(i)
        dirList += [(root + "/" + i) for i in fnmatch.filter(dirs, name)]

        #tmpList = []
        #for i in fnmatch.filter(files, name):
        #    i = root + "/" + i
        #    tmpList.append(i)
        tmpList = [(root + "/" + i) for i in fnmatch.filter(files, name)]

        fileDic[root] = tmpList


        # 再帰検索？
        if opt & FIND_OPT_REFL == False:
            break

    return dirList, fileDic


#=====================================================================
# Attribute
#=====================================================================
ATTRIB_NONE = 0 # なし
ATTRIB_READ = 1 # 読み込み専用 - Marked
ATTRIB_HIDE = 2 # 隠しファイル - Uploaded
ATTRIB_ARCH = 4 # アーカイブ   - Trashed
ATTRIB_NOTF = 8 # ファイルなし

def getAttribute(path):
    """
    ファイルの属性を取得
    path: 属性を調べるファイルのパス
    戻値: ATTRIB_xxxのOR値
    備考: Windows専用関数
    """
    if sys.platform != "win32":
        return ATTRIB_NONE

    if os.path.exists(path) == False:
        return ATTRIB_NOTF

    # シェル経由で実行
    cmd = "attrib " + UniToStr(path)
    p = subprocess.Popen(cmd, shell = True,
                         stdin  = subprocess.PIPE,
                         stdout = subprocess.PIPE)
    out, err = p.communicate()

    # 属性部分だけを残す
    out = out[0:6].replace(' ', '')

    # 属性のチェック
    attrib = ATTRIB_NONE
    for i in out:
        if i == 'A': attrib |= ATTRIB_ARCH
        if i == 'H': attrib |= ATTRIB_HIDE
        if i == 'R': attrib |= ATTRIB_READ

    return attrib


def setAttribute(path, attb):
    """
    ファイルの属性を設定する
    path: 属性を設定するファイルのパス
    attb: 設定する属性(ATTRIB_xxxのOR値)
    備考: Windows専用関数
    """
    if sys.platform != "win32":
        return True

    if os.path.exists(path) == False:
        return False

    # 属性のクリア
    path = UniToStr(path)
    cmd = "attrib -A -H -R " + path
    p = subprocess.Popen(cmd, shell = True,
                         stdin  = subprocess.PIPE,
                         stdout = subprocess.PIPE)
    out, err = p.communicate()

    if attb == ATTRIB_NONE or attb == ATTRIB_NOTF:
        return True

    # 属性を設定
    opt = ""
    if attb & ATTRIB_ARCH: opt += "+A "
    if attb & ATTRIB_HIDE: opt += "+H "
    if attb & ATTRIB_READ: opt += "+R "

    cmd = "attrib " + opt + path
    p = subprocess.Popen(cmd, shell = True,
                         stdin  = subprocess.PIPE,
                         stdout = subprocess.PIPE)
    out, err = p.communicate()

    return True


#=====================================================================
# Unicode
#=====================================================================
def toUnicode(s):
    """
    不特定の文字コードをUnicodeに変換する
    s   : 文字列
    戻値: Unicode文字列
    """
    f = lambda d, enc: d.decode(enc)
    codec = ['shift_jis','utf-8','euc_jp','cp932','iso2022_jp','utf_16']

    for i in codec:
        try:
            return f(s, i)
        except:
            continue
    return s

def toStr(s):
    """
    Unicode以外をstr文字列に変換する
    s   : 文字列
    戻値: str文字列 
    """
    if not isinstance(s, unicode):
        try:
            return str(s)
        except:
            pass
    return s

def UniToStr(s, codec = "UTF8"):
    """
    Unicodeをstr文字列に変換する
    s    : 文字列
    codec: 変換コーデック
    戻値 : str文字列 
    """
    try:
        return s.encode(codec)
    except:
        pass

    try:
        return str(s)
    except:
        return s


# 文字コードを指定してのファイルオープン
# セーブをするためのオープンを想定(open()は自動判別してくれる)
#
# MEMO:2011/11/17 byT.A
# sjisOpen()でファイルをオープンした場合、
# そのファイルオブジェクトで書き込む場合はASCII/UNICODEで渡す。
# ※内部でSJISに変換される
#
# ConifgParserに渡す場合は通常のopen()を使用してください。
# ConfigParserのファイル出力の際にstr()を使用しており、
# これを通る型で渡すと書き込みの際の変換で失敗します。
# (逆にするとstr()で失敗する)
sjisOpen = lambda n, o: codecs.open(n, o, "sjis")
utf8Open = lambda n, o: codecs.open(n, o, "UTF8")


#=====================================================================
# utility
#=====================================================================
def getFileUpdateTime(fileName):
    """
    ファイルの更新時間取得
    fileName: ファイル名
    戻値    : 2000/01/01/00:00:00
    """
    if os.path.exists(fileName):
        return time.strftime("%Y/%m/%d/%X", time.localtime(os.path.getmtime(fileName)))

    return ""

def getLocalTime(day = True, tim = True, div = True):
    """
    現在の日付と時間を取得
    day: 日付を入れる？
    tim 時間を入れる？
    div: 区切りを入れる？(/,day :,time)
    """
    fmt = ""

    if day: fmt += "%Y/%m/%d/" if div else "%Y%m%d"
    if tim: fmt += "%X" if div else "%H%M%S"

    return time.strftime(fmt, time.localtime(time.time()))

def getUserName():
    """
    ユーザ名を取得
    戻値: ユーザ名
    """
    if sys.platform == "win32":
        # windowsは環境変数から取得
        return os.environ.get("USERNAME")
    else:
        #return os.getlogin()
        return os.environ.get("LOGNAME")

def findItem(list, src):
    """
    指定された値がリスト内で最初に現れるインデックスを返す
    list: リストデータ
    src : 検索元の値
    戻値: 0~:最初に一致したインデックス値
          -1:一致する値なし
    """
    idx = 0
    strSrc = unicode(src)
    for i in list:
        if strSrc.find(unicode(i)) >= 0:
            return idx
        idx += 1
    return -1

def delLastPath(path):
    """
    最後のパス(/,\)を取り除く
    path: チェックするパス
    戻値: 取り除いたパス
    """
    if path[-1] == "/" or path[-1] == "\\":
        return path[:-1]
    return path


def rmdir(path, opt = True):
    """
    ディレクトリの削除
    path: 削除するディレクトリ
    opt : サブディレクトリも削除する？
    戻値: 0: 成功
          1: 削除できなかったものがある
    """
    ret = 0

    for root, dirs, files in os.walk(path, not opt):
        # delete files
        for f in files:
            try:
                os.remove(root + "/" + f)
            except OSError:
                ret = 1

        # delete directory
        for d in dirs:
            try:
                os.rmdir(root + "/" + d)
            except OSError:
                ret = 1

        # 再帰しない
        if not opt: break

    # delete root directroy
    try:
        os.rmdir(root)
    except OSError:
        ret = 1

    return ret

def rmfile(path, name = None):
    """
    ファイルの削除
    path: 削除するファイルパス(ワイルドカード対応)
    name: シェル形式のワイルドカードを使用する場合に指定
    戻値: 0: 成功
          1: 削除できなかったものがある
    """
    if path == "":
        raise UserWarning("NotFindPath")

    if name == None:
        path, name = os.path.split(path)

    if name == "":
        raise UserWarning("NotFindName")

    # get match files
    files = fnmatch.filter(os.listdir(path), name)

    # delete files
    ret = 0
    for i in files:
        i = path + "/" + i

        if os.path.isfile(i):
            try:
                os.remove(i)
            except OSError:
                ret = 1

    return ret

def mkdir(path, med = False):
    """
    ディレクトリを作成する
    path: 作成するディレクトリ
    med : 中間のディレクトリも作成する？
    戻値: True : 作成成功/既に作成されている
          False: 作成失敗
    """
    try:
        if not os.path.exists(path):
            #print("mkdir:" + path # VSの出力がUnicode対応していないっぽい)
            if med:
                os.makedirs(path)
            else:
                os.mkdir(path)

    except OSError:
        return False

    return True
