
MIRROR=tmp/Debian-mirror
DBEDIA=tmp/dbedia

# ALL
.PHONY: all
all: update

.PHONY: update
update:
	touch ${MIRROR}/update-heartbeat
	if [ ${MIRROR}/update-heartbeat -nt ${MIRROR}/update-next ]; then \
		rsync -avm --del --include="*.dsc" --include='*/' --exclude='*' rsync://ftp.at.debian.org/debian/ ${MIRROR}/; \
		touch --date "next day" ${MIRROR}/update-next; \
		rm -rf ${DBEDIA}/* \
	fi

# CLEAN
.PHONY: clean distclean
clean:
	rm -f ${MIRROR}/update

distclean:
	rm -f ${MIRROR}/*
	rm -f ${DBEDIA}/*
