
# $@: the target
# $^: all files that the target depends on
# $<: the first file that the target depends on
# $?: files newer than the target that the target depends on

FILES:=.vimrc .gvimrc .gitignore .gitconfig
DIRS:=.vim

.SILENT:

.PHONY: hello
hello:
	echo 'Following files will be produced:'
	echo $(FILES) $(DIRS)

.PHONY: install
install: $(FILES) $(DIRS)
	ln -s -v $(addprefix $(CURDIR)/, $^) $(HOME)

.PHONY: clean
clean:
	$(RM) -v $(addprefix $(HOME)/, $(FILES))
	$(RM) -rv $(addprefix $(HOME)/, $(DIRS))
