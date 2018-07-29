#!/bin/bash
#
# update the doxygen docu with branch in $1

branch=${1:-"develop"}
myDir=`pwd`

# tmp dir with auto-delete if something goes wrong
TMPDIR=`mktemp -d`
trap "{ cd - ; rm -rf $TMPDIR; exit 255; }" SIGINT

# create new dokumentation
cd $TMPDIR
git clone https://github.com/ax3l/lines-are-beautiful.git
cd lines-are-beautiful
git checkout $branch
#sed -i 's/GENERATE_HTML.*=.*NO/GENERATE_HTML     = YES/' Doxyfile
doxygen

# update old documentation
cd $myDir
rsync -r --delete --filter='P update.sh' --filter='P .git' --filter="P .nojekyll" $TMPDIR/lines-are-beautiful/docs/html/ .

rm -rf $TDIR
exit 0
