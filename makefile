
# $@: the target
# $^: all files that the target depends on
# $<: the first file that the target depends on
# $?: files newer than the target that the target depends on

FILES:=.vimrc .gvimrc .gitconfig .config/git/ignore .config/ranger/rc.conf .xmobarrc .Xdefaults .tmux.conf
DIRS:=.vim .xmonad

.SILENT:

.PHONY: hello
hello:
	echo 'Following files will be produced:'
	echo $(FILES) $(DIRS)

define template =
$2: $1
	mkdir -p $(dir $2)
	ln -s -n -v $1 $2
endef

$(foreach e, $(FILES) $(DIRS), \
  $(eval $(call template, $(addprefix $(CURDIR)/, $(e)), $(addprefix $(HOME)/, $(e)))))

.PHONY: install
install: check-existing $(addprefix $(HOME)/, $(FILES) $(DIRS))

# Warn about targets that already exist as real files; make would otherwise
# consider them up to date and skip them silently
.PHONY: check-existing
check-existing:
	for e in $(FILES) $(DIRS); do \
	  t=$$HOME/$$e; \
	  if [ -e "$$t" ] && [ ! -L "$$t" ]; then \
	    echo "warning: $$t already exists and is not a symlink; leaving it as is"; \
	  fi \
	done

.PHONY: clean
clean:
	$(RM) -v $(addprefix $(HOME)/, $(FILES) $(DIRS))
