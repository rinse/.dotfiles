syn case match
syn clear javaScriptReserved


" library
syn keyword javaScriptType Math


" es6
syn keyword javaScriptRepeat of
syn keyword javaScriptType Symbol Promise Map WeakMap Set
syn keyword javaScriptMember iterator prototype constructor

syn keyword javaScriptIdentifier const
" syn keyword javaScriptIdentifier boolean byte char
" syn keyword javaScriptIdentifier float double
" syn keyword javaScriptIdentifier short int long
" syn keyword javaScriptIdentifier super

syn keyword javaScriptStatement	yield

syn keyword javaScriptStorageClass static
" syn keyword javaScriptStorageClass volatile final transient
syn keyword javaScriptClassDecl class extends
" syn keyword javaScriptClassDecl enum interface implements
" syn keyword javaScriptScopeDecl public private protected abstract

syn keyword javaScriptExternal import export
" syn keyword javaScriptExternal package

syn region javaScriptInterpolated start=+${+ end=+}+ contained
syn region javaSctiptStringR start=+`+  end=+`+ contains=javaScriptInterpolated


" reserved words
syn keyword javaScriptReserved abstract boolean byte char debugger double enum final float goto implements int interface long native package private protected public short super synchronized throws transient volatile 


" highlighting
hi def link javaSctiptStringR       String
hi def link javaScriptInterpolated  javaScriptIdentifier

hi def link javaScriptStorageClass  StorageClass
hi def link javaScriptClassDecl     StorageClass
hi def link javaScriptScopeDecl     StorageClass

hi def link javaScriptExternal      Include
