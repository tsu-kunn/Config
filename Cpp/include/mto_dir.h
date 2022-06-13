/*=============================================================================
// Fast 2011/08/31
// Last 2022/06/13  Ver1.10                                      (c)Tsuyoshi.A
=============================================================================*/
#ifndef _MTO_DIR_H_
#define _MTO_DIR_H_

// POSIX準拠の環境のみ使える
#if defined(LINUX) || defined(UNIX)

#include <dirent.h>
#include <sys/stat.h>

namespace MtoLib {

class Dir {
private:
	DIR				*m_pDir;
	std::string		m_Path;

public:
	Dir(void) : m_pDir(NULL) {}

	~Dir(void) 
	{
		this->Close();
	}

	// ディレクトリオープン
	// path: ディレクトリパス
	bool Open(const std::string &path)
	{
		if ((m_pDir = opendir(path.c_str())) == NULL) {
			std::string err = std::string("can't open the directory:") + path.c_str() + "\n";
			throw err;
			return false;
		}

		m_Path = path;
		return true;
	}

	// ファイルパス取得
	// outPath: ファイルパス保存先
	// bDir   : ファイル名にパスをつける？
	// 戻値   : falseで終了
	bool getFilePath(std::string &outPath, const bool bDir)
	{
		struct dirent *dent;
		struct stat statBuf;

		while ((dent = readdir(m_pDir)) != NULL) {
			// ディレクトリは処理しない
			if (strcmp(dent->d_name, ".") == 0) continue;
			if (strcmp(dent->d_name, "..") == 0) continue;

			if (bDir) {
				outPath = m_Path + "/" + dent->d_name;
			} else {
				outPath = dent->d_name;
			}

			stat(outPath.c_str(), &statBuf);
			if (S_ISDIR(statBuf.st_mode)) continue;

			return true;
		}

		outPath.clear();
		return false;
	}

	// ディレクトリパス取得
	// outPath: ファイルパス保存先
	// bDir   : ファイル名にパスをつける？
	// 戻値   : falseで終了
	bool getDirPath(std::string &outPath, const bool bDir)
	{
		struct dirent *dent;
		struct stat statBuf;

		while ((dent = readdir(m_pDir)) != NULL) {
			// ルートとカレントディレクトリは処理しない
			if (strcmp(dent->d_name, ".") == 0) continue;
			if (strcmp(dent->d_name, "..") == 0) continue;

			if (bDir) {
				outPath = m_Path + "/" + dent->d_name;
			} else {
				outPath = dent->d_name;
			}

			stat(outPath.c_str(), &statBuf);
			if (!S_ISDIR(statBuf.st_mode)) continue;

			return true;
		}

		outPath.clear();
		return false;
	}

    // ディレクトリストリームを先頭に移動 
    void seekDirSet(void)
    {
        if (m_pDir == NULL) return;

        seekdir(m_pDir, 0);
    }

	// ディレクトリパスの取得
	std::string getDirPath(void) const {return m_Path;}

	// ディレクトリクローズ
	void Close(void)
	{
		if (m_pDir != NULL) {
			closedir(m_pDir);
			m_pDir = NULL;
		}
	}
};

} // namespace MtoLib

#endif // LINUX
#endif
