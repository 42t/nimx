import os
import strutils
import streams

when defined(Android):
    const 
        ASSET_MANAGER_HEADER = "<android/asset_manager.h>"

        AASSET_MODE_UNKNOWN {.header: ASSET_MANAGER_HEADER, importc: "AASSET_MODE_UNKNOWN".} = 0
        AASSET_MODE_RANDOM {.header: ASSET_MANAGER_HEADER, importc: "AASSET_MODE_UNKNOWN".} = 1
        AASSET_MODE_STREAMING {.header: ASSET_MANAGER_HEADER, importc: "AASSET_MODE_UNKNOWN".} = 2
        AASSET_MODE_BUFFER {.header: ASSET_MANAGER_HEADER, importc: "AASSET_MODE_UNKNOWN".} = 3

    type 
        AAssetManagerObj {.final, header: ASSET_MANAGER_HEADER, importc: "AAssetManager".} = object
        AAssetManager = ptr AAssetManagerObj
        
        AAssetDirObj {.final, header: ASSET_MANAGER_HEADER, importc: "AAssetDir".} = object
        AAssetDir = ptr AAssetDirObj

        AAssetObj {.final, header: ASSET_MANAGER_HEADER, importc: "AAsset".} = object
        AAsset = ptr AAssetObj

type
    Resource* = ref ResourceObj
    ResourceObj* = object
        size*: int
        data*: pointer


when defined(Android):
    # Android AssetManager methods
    proc openDir(mgr: AAssetManager, dirName: cstring): AAssetDir {.header: ASSET_MANAGER_HEADER, importc: "AAssetManager_openDir".}
    proc open(mgr: AAssetManager, filename: cstring, mode: int): AAsset {.header: ASSET_MANAGER_HEADER, importc: "AAssetManager_open".}

    # Android AssetDir methods
    proc getNextFileName(assetDir: AAssetDir): cstring {.header: ASSET_MANAGER_HEADER, importc: "AAssetDir_getNextFileName".}
    proc rewind(assetDir: AAssetDir) {.header: ASSET_MANAGER_HEADER, importc: "AAssetDir_rewind".}
    proc close(assetDir: AAssetDir) {.header: ASSET_MANAGER_HEADER, importc: "AAssetDir_close".}

    proc read(asset: AAsset, buf: pointer, count: BiggestInt): int {.header: ASSET_MANAGER_HEADER, importc: "AAsset_read".}
    proc seek(asset: AAsset, offset: BiggestInt, whence: BiggestInt): BiggestInt {.header: ASSET_MANAGER_HEADER, importc: "AAsset_seek".}
    proc close(asset: AAsset) {.header: ASSET_MANAGER_HEADER, importc: "AAsset_close".}
    proc getBuffer(asset: AAsset): cstring {.header: ASSET_MANAGER_HEADER, importc: "AAsset_getBuffer".}
    proc getLength(asset: AAsset): BiggestInt {.header: ASSET_MANAGER_HEADER, importc: "AAsset_getLength".}
    proc getRemainingLength(asset: AAsset): BiggestInt {.header: ASSET_MANAGER_HEADER, importc: "AAsset_getRemainingLength".}
    proc openFileDescriptor(asset: AAsset, outStart: ptr BiggestInt, outLength: ptr BiggestInt): BiggestInt {.
        header: ASSET_MANAGER_HEADER, importc: "AAsset_openFileDescriptor".}
    proc isAllocated(asset: AAsset): BiggestInt {.header: ASSET_MANAGER_HEADER, importc: "AAsset_isAllocated".}

    proc findResourceInAPK(mgr: AAssetManager, dir: AAssetDir, node: string): AAsset =
        defer: dir.close()
        var currentFileName: cstring = dir.getNextFileName()
        while currentFileName != "":
            # Try to open dir
            let nestedDir: AAssetDir = mgr.openDir(currentFileName)
            # We should go deeper
            if nestedDir != nil:
                return findResourceInAPK(mgr, nestedDir, node)
            # It's a file
            else:
                if node == currentFileName:
                    return mgr.open(currentFileName, 3)  # aaset_node_buffer asset opening mode

when not defined(Android):
    proc findResourceInFS(resourceName: string): Resource =
        for path in walkDirRec(getAppDir(), {pcFile, pcDir}):
            if path.contains(resourceName):
                let f: File = open(path)
                defer: f.close()

                let i: FileInfo = getFileInfo(f)

                let source = newFileStream(path, fmRead)
                defer: source.close()
                
                new(result)
                result.size = int(i.size)
                result.data = alloc(result.size)
                discard Stream(source).readData(result.data, result.size)
                return
        result = nil

proc loadResourceByName*(resourceName: string): Resource =
    when defined(android):
        # Android code for resources loading
        # Finding assets
        result = Resource.new
        let mgr: AAssetManager = AAssetManager.new
        let root: AAssetDir = AAssetManager.openDir("")
        let ass: AAsset = findResourceInAPK(mgr, root, resourceName)
        # Reading the result
        result.size = ass.getLength()
        result.data = alloc(result.size)
        ass.read(ass, result.data, result.size)
        ass.close()
    elif defined(ios) or defined(macos) or defined(linux) or defined(win32):
        # Generic resource loading from file
        result = findResourceInFS(resourceName)


proc freeResource*(res: Resource) {.discardable.} =
    res.size = 0
    dealloc(res.data)

when isMainModule:
    # Test for non-existing resource
    let r1: Resource = loadResourceByName("non-existing")
    assert(r1 == nil)

    # Test for existing resource
    discard execShellCmd("mkdir -p " & getAppDir() & "/resources/nested/")
    discard execShellCmd("(echo \"asdsadasdsadasdadsad\") > " & getAppDir() & "/resources/nested/somefile.png")

    let r2: Resource = loadResourceByName("somefile.png")
    assert(r2 != nil)
    freeResource(r2)

    discard execShellCmd("rm -r " & getAppDir() & "/resources/")
