#include "mto_common.h"
#include "mto_dir.h"

/*=======================================================================
【機能】ディレクトリオープン
【引数】pDirInfo: ディレクトリ情報のポインタ
        path    : ディレクトリパス(末尾の"/"は不要)
【戻値】true: オープン成功
 =======================================================================*/
bool mto_dir_open(struct DirInfo *pDirInfo, const char *path)
{
    if (pDirInfo == NULL) return false;
    if (path == NULL) return false;

    if ((pDirInfo->pDir = opendir(path)) == NULL) {
        printf("can't open the directory: %s\n", path);
        return false;
    }

    strncpy(pDirInfo->path, path, sizeof(pDirInfo->path));

    return true;
}

/*=======================================================================
【機能】ファイルパスの取得
【引数】pDirInfo: ディレクトリ情報のポインタ 
        pOutPath: ファイルパス保存先
        pathSize: ファイルパス保存先のサイズ
        bDir    : ファイル名にパスをつける？
【戻値】falseで終了 
 =======================================================================*/
bool mto_dir_get_filepath(struct DirInfo *pDirInfo, char *pOutPath, const uint32_t pathSize, const bool bDir)
{
    if (pDirInfo == NULL) return false;
    if (pOutPath == NULL) return false;

    struct dirent *dent;
    struct stat statBuf;

    while ((dent = readdir(pDirInfo->pDir)) != NULL) {
        // ディレクトリは処理しない
        if (strcmp(dent->d_name, ".") == 0) continue;
        if (strcmp(dent->d_name, "..") == 0) continue;

        if (bDir) {
            snprintf(pOutPath, pathSize, "%s/%s", pDirInfo->path, dent->d_name);
        } else {
            strncpy(pOutPath, dent->d_name, pathSize);
        }

        stat(pOutPath, &statBuf);
        if (S_ISDIR(statBuf.st_mode)) continue;

        return true;
    }

    return false;
}

/*=======================================================================
【機能】ディレクトリパスの取得
【引数】pDirInfo: ディレクトリ情報のポインタ 
        pOutPath: ディレクトリパス保存先
        pathSize: ディレクトリパス保存先のサイズ
        bDir    : ディレクトリにパスをつける？
【戻値】falseで終了 
 =======================================================================*/
bool mto_dir_get_dirpath(struct DirInfo *pDirInfo, char *pOutPath, const uint32_t pathSize, const bool bDir)
{
    if (pDirInfo == NULL) return false;
    if (pOutPath == NULL) return false;

    struct dirent *dent;
    struct stat statBuf;

    while ((dent = readdir(pDirInfo->pDir)) != NULL) {
        // ルートとカレントディレクトリは処理しない
        if (strcmp(dent->d_name, ".") == 0) continue;
        if (strcmp(dent->d_name, "..") == 0) continue;

        if (bDir) {
            snprintf(pOutPath, pathSize, "%s/%s", pDirInfo->path, dent->d_name);
        } else {
            strncpy(pOutPath, dent->d_name, pathSize);
        }

        stat(pOutPath, &statBuf);
        if (!S_ISDIR(statBuf.st_mode)) continue;

        return true;
    }

    return false;
}

/*=======================================================================
【機能】ディレクトリストリームを先頭に移動
【引数】pDirInfo: ディレクトリ情報のポインタ 
【戻値】なし
 =======================================================================*/
void mto_dir_seek_set(struct DirInfo *pDirInfo)
{
    if (pDirInfo == NULL) return;

    seekdir(pDirInfo->pDir, 0);
}

/*=======================================================================
【機能】ディレクトリパスの取得
【引数】pDirInfo: ディレクトリ情報のポインタ 
【戻値】ディレクトリパスのポインタ
 =======================================================================*/
const char *mto_dir_get_dirinfo_path(const struct DirInfo *pDirInfo)
{
    if (pDirInfo == NULL) return NULL;

    return pDirInfo->path;
}

/*=======================================================================
【機能】ディレクトリクローズ
【引数】pDirInfo: ディレクトリ情報のポインタ 
【戻値】ディレクトリパスのポインタ
 =======================================================================*/
void mto_dir_close(struct DirInfo *pDirInfo)
{
    if (pDirInfo != NULL && pDirInfo->pDir != NULL) {
        closedir(pDirInfo->pDir);
        pDirInfo->pDir = NULL;
    }
}


