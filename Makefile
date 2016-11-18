SRC := $(shell find . \( -path './tmp' -o -path './test' \) -prune -o -type f -name '*.vim' -print)

test: test/vint
	vint $(SRC)

test/vint:
	git clone --recursive https://github.com/Kuniwak/vint.git test/vint
	cd test/vint; python setup.py install $(PIP_FLAGS)

debug:
	@echo $(SRC)

clean:
	${RM} -r test/vint
	pip uninstall -y ansicolor chardet vim-vint

.PHONY: test debug clean
