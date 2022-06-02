#include "mto_common.h"
#include "mto_dir.h"


/*========================================================
【機能】操作説明
=========================================================*/
static void _info_draw(void)
{
	printf("|||||||||||||||          mkedat          ||||||||||||||||\n");
	printf("mkedat.exe Version 0.30        (c)Tsuyoshi.A-APR 12 2010-\n");
	printf("\n");
	printf("mkedat [option] [contentID] [in file] [out file]\n");
	printf("    [option]\n");
	printf("       -? : ヘルプ出力\n");
	printf("\n");
}

/*========================================================
【機能】オプションの有無を調べる
=========================================================*/
static int _check_option(int argc, char *argv[])
{
	int opt = 1;

	// 引数なし
	if (argc == 1) {
		_info_draw();
		return 0;
	}

	if (argc > 5) {
		printf("引数の指定が不正です。\n");
		return 0;
	}

	// オプションがある？
	while (argv[opt][0] == '-') {
		switch (argv[opt][1]) {
		case '?':
			_info_draw();
			return 0;

		default:
			printf("サポートされていない拡張子です\n");
			printf("『mkedat -?』でヘルプ\n");
			return 0;
		}

		if (++opt > 2) {
			printf("オプションの指定が不正です。\n");
			return 0;
		}
	}

	return opt;
}

/*========================================================
【機能】終了処理
=========================================================*/
static void _release(void)
{
}



	/*------------------------------------------------------------*/
	/*------------------------------------------------------------*/
	/*------------------------------------------------------------*/
	/*------------------------------------------------------------*/
	/*------------------------------------------------------------*/



/*========================================================
【機能】余白削除
=========================================================*/
int main(int argc, char *argv[])
{
	SET_CRTDBG();

	int opt_idx;

	// オプションチェック
	if (!(opt_idx = _check_option(argc, argv))) {
		_release();
		return 1;
	}

    struct DirInfo dir_info = {NULL, {0}};

    if (mto_open_dir(&dir_info, ".")) {
        char path[_MAX_PATH] = {0};

        while (mto_get_filepath(&dir_info, path, sizeof(path), true)) {
            printf("%s\n", path);
        }

        mto_seek_set_dir(&dir_info);

        while (mto_get_dirpath(&dir_info, path, sizeof(path), false)) {
            printf("%s\n", path);
        }

        mto_close_dir(&dir_info);
    }

	// 終了
	_release();

	return 0;
}
