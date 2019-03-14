DEPS_LIST_FILE=$1
shift
DIRS=$@
if [[ $@ = ""  ||  $1 = "" ]]; then
    echo "Usage: find_unsused.sh <dependecy file> <directories to look into...>"
    exit 1
fi
echo Using dependency list file: $DEPS_LIST_FILE
echo Looking into directories: $DIRS
echo
echo LIBRARY - IMPORT - STATUS
for dep in `cat $DEPS_LIST_FILE`; do
    echo -n $dep
    IMPORT_NAME=$(pip show -f $dep 2>/dev/null | grep "\.py$" | sed 's/.py//g; s,/__init__,,g; s,/,.,g' | head -n 1 | awk '{print $1}' | cut -d '.' -f 1)
    if [[ $IMPORT_NAME = "" ]]; then
        echo " - ERROR - NOT FOUND";
        continue;
    fi
    echo -n " - $IMPORT_NAME"
    git grep -q $IMPORT_NAME $DIRS
    status=$?
    if [ $status -eq 0 ]; then
        echo " - used"
    else
        echo " - UNUSED"
    fi
done
