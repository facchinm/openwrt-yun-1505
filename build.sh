while getopts 'acshj:' flag; do
	case "${flag}" in
                h)
                        echo "Build script for Yun/Yun101/Yun Shield Openwrt"
                        echo " "
                        echo "options:"
                        echo "-h,			show brief help"
                        echo "-a,			compile all packages"
                        echo "-c,			clean before building"
                        echo "-s,			safe mode, single job and verbose output"
                        exit 0
                        ;;
                a)
                        export COMPILEALL=1
			;;
                s)	
			export JOBS=1
			export EXTRAFLAGS="V=s"
			;;
                c)
			export CLEAN=1
                        ;;
		j)
			shift
                        if test $# -gt 0; then
                                export JOBS=$1
			fi
			shift
			;;
		*)	
			export COMPILEALL=0
			export CLEAN=0
			export JOBS=1
			;;
        esac
done

if [ x$CLEAN == x1 ]; then
make clean
fi

if [ x$COMPILEALL == x1 ]; then
cp config.full .config
else
cp config.default .config
fi

./scripts/feeds uninstall -a
./scripts/feeds install -a -d m

make -j$JOBS IGNORE_ERRORS=m $EXTRAFLAGS

