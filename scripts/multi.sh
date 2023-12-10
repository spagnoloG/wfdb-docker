# !/bin/bash

set -eux

if [ -f "eval1.txt" ]; then
    rm eval1.txt
fi

if [ -f "eval2.txt" ]; then
    rm eval2.txt
fi


FILES="*.dat"

for f in $FILES
do
  f=$(basename $f)
  f=${f%.*}

  echo  $f 
  ./qrs_detect -r $f

  docker run -it --rm -v "$(pwd)":/data ghcr.io/spagnolog/wfdb-docker:main bxb -r "/data/$f" -a atr qrs -l /data/eval1.txt /data/eval2.txt
done

docker run -it --rm -v "$(pwd)":/data ghcr.io/spagnolog/wfdb-docker:main sumstats /data/eval1.txt /data/eval2.txt > results.txt 
