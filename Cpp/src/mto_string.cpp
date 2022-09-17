#include "mto_common.h"
#include "mto_string.h"

#include <fstream>
#include <sstream>
#include <iomanip>


/*========================================================
【機能】文字列分割
【引数】str  ：文字列
        delim：デリミタ
【戻値】分割された文字列
=========================================================*/
std::vector<std::string> MtoLib::Str::Split(std::string str, const std::string &delim)
{
	std::vector<std::string> strList;
	std::size_t idx = 0;

	while ((idx = str.find_first_of(delim)) != std::string::npos) {
		if (idx > 0) {
			strList.push_back(str.substr(0, idx));
		}
		str = str.substr(idx + 1);
	}

	if (str.length() > 0) {
		strList.push_back(str);
	}

	return strList;
}

/*========================================================
【機能】ファイルパス分割
【引数】path ：ファイルパス
        pPwd ：保存先・ファイル位置
        pName：保存先・ファイル名
        pExt ：保存先・拡張子
【備考】不要の場合はNULLを指定してください
=========================================================*/
void MtoLib::Str::SplitPath(std::string path, std::string *pPwd, std::string *pName, std::string *pExt)
{
#ifdef _MSC_VER
	static const char *pDiv = "\\";
#else
	static const char *pDiv = "/";
#endif

	std::size_t idx;
	std::string pwd, name, ext;

	// pwd
	if ((idx = path.find_last_of(pDiv)) != std::string::npos) {
		pwd  = path.substr(0, (idx + 1));
		path = path.substr(idx + 1);
	}

	// ファイル名
	if ((idx = path.find_last_of(".")) != std::string::npos) {
		name = path.substr(0, idx);
		ext  = path.substr(idx);
	} else {
		name = path;
	}

	if (pPwd  != NULL) *pPwd  = pwd;
	if (pName != NULL) *pName = name;
	if (pExt  != NULL) *pExt  = ext;
}

/*========================================================
【機能】文字列から連番を取得
【引数】str    ：文字列
        paddNum：パディング数
        pDiv   ：区切り文字(default:"_")
        pIdx   ：連番数列開始位置の保存先(default:NULL)
【戻値】連番数列
=========================================================*/
std::string MtoLib::Str::Sequence(const std::string &str, const sint32 paddNum, const char *pDiv, sint32 *pIdx)
{
	int i, n;
	std::size_t idx = 0;
	std::string seqStr;

	do {
		if (pDiv != NULL) {
			if ((idx = str.find(pDiv, idx)) == std::string::npos) {
				throw "sequence number not found!!";
				seqStr.clear();
				return seqStr;
			}
		}

		seqStr = std::string(str, ++idx, paddNum);
		for (i = n = 0; i < paddNum; i++) {
			n += MtoIsNumber(seqStr[i]);
		}
	} while (n != paddNum);

	if (pIdx != NULL) *pIdx = idx;

	return seqStr;
}

/*========================================================
【機能】数字を文字列に変換
【引数】num ：数字
        padd：パディング数
【戻値】数字の文字列
=========================================================*/
std::string MtoLib::Str::itos(const sint32 num, const sint32 padd)
{
	std::ostringstream sstream;
	sstream << std::setw(padd) << std::setfill('0') << num;
	return sstream.str();
}

/*========================================================
【機能】文字列を数字に変換
【引数】str：文字列
【戻値】数字
=========================================================*/
sint32 MtoLib::Str::stoi(const std::string &str)
{
	sint32 ret;
	std::istringstream timestream(str);
	timestream >> ret;
	return ret;
}

float MtoLib::Str::stof(const std::string &str)
{
	float ret;
	std::istringstream timestream(str);
	timestream >> ret;
	return ret;
}
