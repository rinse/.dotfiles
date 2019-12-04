
# $@: the target
# $^: all files that the target depends on
# $<: the first file that the target depends on
# $?: files newer than the target that the target depends on

FILES:=.vimrc .gvimrc .gitconfig .config/git/ignore .xmobarrc
DIRS:=.vim .xmonad

.SILENT:

.PHONY: hello
hello:
	echo 'Following files will be produced:'
	echo $(FILES) $(DIRS)

define template =
$2: $1
	mkdir -p $(dir $2)
	ln -s -v $1 $2
endef

$(foreach e, $(FILES) $(DIRS), \
  $(eval $(call template, $(addprefix $(CURDIR)/, $(e)), $(addprefix $(HOME)/, $(e)))))

.PHONY: install
install: $(addprefix $(HOME)/, $(FILES) $(DIRS))

.PHONY: clean
clean:
	$(RM) -v $(addprefix $(HOME)/, $(FILES))
	$(RM) -rv $(addprefix $(HOME)/, $(DIRS))
