FROM pandoc/latex:2.6

RUN tlmgr --verify-repo=all install tex-gyre titlesec
RUN tlmgr --verify-repo=all install roboto
RUN tlmgr --verify-repo=all install fontaxes
RUN tlmgr --verify-repo=all install lato
RUN tlmgr --verify-repo=all install inconsolata
