syn case match

if !exists("cpp_no_cpp11")
  syn region cppAttributeString start=+"+ end=+"+ contained
  syn region cppAttribute start=+\[\[+ end=+]]+ contains=cppAttributeString
endif

" highlighting
hi def link cppAttributeString  String
hi def link cppAttribute        Special
