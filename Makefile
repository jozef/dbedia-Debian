
MIRROR=tmp/Debian-mirror
WWW_FOLDER=tmp/dbedia

# ALL
.PHONY: all
all: update

.PHONY: update
update:
	touch ${MIRROR}/update-heartbeat
	if [ ${MIRROR}/update-heartbeat -nt ${MIRROR}/update-next ]; then \
		rsync -avm --del --exclude-from=exclude.txt --include="*.deb" --include="*.dsc" --include='*/' --exclude='*' rsync://ftp.at.debian.org/debian/ ${MIRROR}/; \
		rm -rf ${WWW_FOLDER}/*; \
		script/dbedia-debian-dsc2json; \
		script/dbedia-debian-perldeb2json; \
		find ${WWW_FOLDER}/ -name '*.json' -exec gzip -f -9 {} \; ; \
		touch --date "12h" ${MIRROR}/update-next; \
	fi

# install
.PHONY: install
install: all
	mkdir -p ${DESTDIR}/var/www/dbedia-Debian
	cp -r ${WWW_FOLDER}/* ${DESTDIR}/var/www/dbedia-Debian/
	perl -MJSON::XS -le 'print JSON::XS->new->encode({ build_time => time() });' > ${DESTDIR}/var/www/dbedia-Debian/build.json
	mkdir -p ${DESTDIR}/etc/dbedia/sites-available
	cp etc/dbedia-Debian.conf ${DESTDIR}/etc/dbedia/sites-available/

# create debian package
.PHONY: deb
deb: all
	debuild -b -us -uc --lintian-opts --no-lintian

# CLEAN
.PHONY: clean distclean
clean:
	touch ${MIRROR}/update-next
	rm -rf ${WWW_FOLDER}/*

distclean:
	rm -rf ${MIRROR}/*
	rm -rf ${WWW_FOLDER}/*
