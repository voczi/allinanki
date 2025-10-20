#define UNICODE

#pragma comment(lib, "Ole32.lib")
#pragma comment(lib, "comsuppw.lib")

#include "windows.h"
#include "shobjidl.h"
#include "objbase.h"
#include "objidl.h"
#include "shlguid.h"
#include "propsys.h"
#include "PropIdl.h"
#include "comdef.h"
#include "stdio.h"
#include "Propkey.h"

HRESULT createShortcut(LPCWSTR targetPath, LPCWSTR shortcutPath, LPCWSTR workingDirectory, LPWSTR appUserModelId)
{
    HRESULT hres;

    hres = CoInitialize(NULL);
    if (FAILED(hres))
    {
        return hres;
    }

    IShellLink *shellLink;
    hres = CoCreateInstance(CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, IID_IShellLink, (LPVOID *)&shellLink);
    if (FAILED(hres))
    {
        return hres;
    }
    hres = shellLink->SetPath(targetPath);
    if (FAILED(hres))
    {
        return hres;
    }
    hres = shellLink->SetWorkingDirectory(workingDirectory);
    if (FAILED(hres))
    {
        return hres;
    }

    IPropertyStore *propertyStore;
    hres = shellLink->QueryInterface(IID_PPV_ARGS(&propertyStore));
    if (FAILED(hres))
    {
        return hres;
    }

    PROPVARIANT propVariant;
    PropVariantInit(&propVariant);
    propVariant.vt = VT_LPWSTR;
    propVariant.pwszVal = appUserModelId;
    hres = propertyStore->SetValue(PKEY_AppUserModel_ID, propVariant);
    if (FAILED(hres))
    {
        return hres;
    }
    propVariant.pwszVal = NULL;
    hres = PropVariantClear(&propVariant);
    if (FAILED(hres))
    {
        return hres;
    }

    IPersistFile *persistFile;
    hres = shellLink->QueryInterface(IID_IPersistFile, (LPVOID *)&persistFile);
    if (SUCCEEDED(hres))
    {
        hres = propertyStore->Commit();
        if (FAILED(hres))
        {
            return hres;
        }
        hres = persistFile->Save(shortcutPath, TRUE);
        if (FAILED(hres))
        {
            return hres;
        }
        propertyStore->Release();
        persistFile->Release();
    }
    shellLink->Release();

    return hres;
}

int printUsage()
{
    printf_s("Usage: create-shortcut.exe target_path shortcut_path working_directory appusermodel_id");
    return 1;
}

int wmain(int argc, wchar_t *argv[])
{
    wchar_t *targetPath = argv[1];
    wchar_t *shortcutPath = argv[2];
    wchar_t *workingDirectory = argv[3];
    wchar_t *appUserModelId = argv[4];
    wchar_t *lastArg = argv[5];

    if (targetPath == NULL || shortcutPath == NULL || workingDirectory == NULL || appUserModelId == NULL || lastArg != NULL)
    {
        return printUsage();
    }

    HRESULT hres = createShortcut(targetPath, shortcutPath, workingDirectory, appUserModelId);
    if (FAILED(hres))
    {
        _com_error comError(hres);
        LPCWSTR errorMessage = comError.ErrorMessage();
        wprintf_s(L"%s (0x%08lx)", errorMessage, hres);
        return hres;
    }

    wprintf_s(L"Successfully created a shortcut at: %s", shortcutPath);
    return 0;
}