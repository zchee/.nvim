FROM zchee/neovim-python
MAINTAINER zchee <k@zchee.io>

RUN pip install jedi \
	&& pip3 install jedi
