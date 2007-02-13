/* Copyright (C) 2007 SSH Communications Security, Helsinki, Finland
 *
 * This code is released under the MLton license, a BSD-style license.
 * See the LICENSE file or http://mlton.org/License for details.
 */

/*
 * Specifications of Windows utilities.
 */

#ifndef WIN_H_20070205
#define WIN_H_20070205

/************************************************************************/

#ifndef WIN_TYPEDEF
# define WIN_TYPEDEF(name, type) typedef type name
#endif

#ifndef WIN_CONST
# define WIN_CONST(name, type) extern type win_##name
#endif

#ifndef WIN_FUNCTION
# define WIN_FUNCTION(name, result, arity, args) extern result win_##name args
#endif

/************************************************************************/

WIN_TYPEDEF(BYTE, unsigned char);
WIN_TYPEDEF(DWORD, unsigned long);
WIN_TYPEDEF(LONG, long);

WIN_TYPEDEF(LPBYTE, BYTE *);
WIN_TYPEDEF(LPDWORD, DWORD *);

WIN_TYPEDEF(LPCTSTR, const char *);
WIN_TYPEDEF(LPTSTR, char *);

WIN_TYPEDEF(LPSECURITY_ATTRIBUTES, void *);
WIN_TYPEDEF(PFILETIME, void *);

/************************************************************************/

WIN_FUNCTION(GetLastError, DWORD, 0, (void));

WIN_CONST(ERROR_INSUFFICIENT_BUFFER, DWORD);
WIN_CONST(ERROR_MORE_DATA, DWORD);
WIN_CONST(ERROR_NO_MORE_ITEMS, DWORD);
WIN_CONST(ERROR_SUCCESS, DWORD);

/************************************************************************/

WIN_TYPEDEF(HMODULE, void *);

WIN_FUNCTION(GetModuleFileName, DWORD, 3, (HMODULE, LPTSTR, DWORD));

/************************************************************************/

WIN_FUNCTION(GetShortPathName, DWORD, 3, (LPCTSTR, LPTSTR, DWORD));

/************************************************************************/

WIN_TYPEDEF(HLOCAL, void *);

WIN_FUNCTION(LocalFree, HLOCAL, 1, (HLOCAL));

/************************************************************************/

WIN_TYPEDEF(HKEY, void *);

WIN_CONST(HKEY_CLASSES_ROOT, HKEY);
WIN_CONST(HKEY_CURRENT_CONFIG, HKEY);
WIN_CONST(HKEY_CURRENT_USER, HKEY);
WIN_CONST(HKEY_DYN_DATA, HKEY);
WIN_CONST(HKEY_LOCAL_MACHINE, HKEY);
WIN_CONST(HKEY_PERFORMANCE_DATA, HKEY);
WIN_CONST(HKEY_USERS, HKEY);

WIN_TYPEDEF(PHKEY, HKEY *);

WIN_TYPEDEF(REGSAM, unsigned long);

WIN_CONST(KEY_ALL_ACCESS, REGSAM);
WIN_CONST(KEY_CREATE_LINK, REGSAM);
WIN_CONST(KEY_CREATE_SUB_KEY, REGSAM);
WIN_CONST(KEY_ENUMERATE_SUB_KEYS, REGSAM);
WIN_CONST(KEY_EXECUTE, REGSAM);
WIN_CONST(KEY_NOTIFY, REGSAM);
WIN_CONST(KEY_QUERY_VALUE, REGSAM);
WIN_CONST(KEY_READ, REGSAM);
WIN_CONST(KEY_SET_VALUE, REGSAM);
WIN_CONST(KEY_WRITE, REGSAM);

WIN_CONST(REG_BINARY, DWORD);
WIN_CONST(REG_DWORD, DWORD);
WIN_CONST(REG_DWORD_LITTLE_ENDIAN, DWORD);
WIN_CONST(REG_DWORD_BIG_ENDIAN, DWORD);
WIN_CONST(REG_EXPAND_SZ, DWORD);
WIN_CONST(REG_LINK, DWORD);
WIN_CONST(REG_MULTI_SZ, DWORD);
WIN_CONST(REG_NONE, DWORD);
WIN_CONST(REG_QWORD, DWORD);
WIN_CONST(REG_QWORD_LITTLE_ENDIAN, DWORD);
WIN_CONST(REG_SZ, DWORD);

WIN_CONST(REG_CREATED_NEW_KEY, DWORD);
WIN_CONST(REG_OPENED_EXISTING_KEY, DWORD);

WIN_FUNCTION(RegCloseKey, LONG, 1, (HKEY));
WIN_FUNCTION(RegCreateKeyEx, LONG, 9,
             (HKEY, LPCTSTR, DWORD, LPTSTR, DWORD, REGSAM,
              LPSECURITY_ATTRIBUTES, PHKEY, LPDWORD));
WIN_FUNCTION(RegDeleteKey, LONG, 2, (HKEY, LPCTSTR));
WIN_FUNCTION(RegDeleteValue, LONG, 2, (HKEY, LPCTSTR));
WIN_FUNCTION(RegEnumKeyEx, LONG, 8,
             (HKEY, DWORD, LPTSTR, LPDWORD, LPDWORD, LPTSTR, LPDWORD,
              PFILETIME));
WIN_FUNCTION(RegEnumValue, LONG, 8,
             (HKEY, DWORD, LPTSTR, LPDWORD, LPDWORD, LPDWORD, LPBYTE, LPDWORD));
WIN_FUNCTION(RegOpenKeyEx, LONG, 5, (HKEY, LPCTSTR, DWORD, REGSAM, PHKEY));
WIN_FUNCTION(RegQueryValueEx, LONG, 6,
             (HKEY, LPCTSTR, LPDWORD, LPDWORD, LPBYTE, LPDWORD));
WIN_FUNCTION(RegSetValueEx, LONG, 6,
             (HKEY, LPCTSTR, DWORD, DWORD, const BYTE *, DWORD));

/************************************************************************/

LPTSTR win_FormatErrorLocalAlloc(DWORD error);

#endif