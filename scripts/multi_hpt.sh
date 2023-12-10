# !/bin/bash

set -eux

FILES="*.dat"

PARAMS_gamma=(0.14 0.15 0.16)
PARAMS_alpha=(0.04 0.05 0.06)
PARAMS_H=(5 7)
PARAMS_L=(36 38 40)
PARAMS_M=(60 80 100 120 140 160)


for gamma in "${PARAMS_gamma[@]}"; do
    for alpha in "${PARAMS_alpha[@]}"; do
        for H in "${PARAMS_H[@]}"; do
            for L in "${PARAMS_L[@]}"; do
                for M in "${PARAMS_M[@]}"; do
                    rm -rf eval1.txt
                    rm -rf eval2.txt
                    for f in $FILES
                    do
                        f=$(basename $f)
                        f=${f%.*}
                        echo  $f 
                        ./qrs_detect -r $f -G $gamma -A $alpha -H $H -L $L -M $M

                        docker run -it --rm -v "$(pwd)":/data ghcr.io/spagnolog/wfdb-docker:main bxb -r "/data/$f" -a atr qrs -l /data/eval1.txt /data/eval2.txt
                    done
                    echo "gamma: $gamma alpha: $alpha H: $H L: $L M: $M" >> results.txt
                    docker run -it --rm -v "$(pwd)":/data ghcr.io/spagnolog/wfdb-docker:main sumstats /data/eval1.txt /data/eval2.txt >> results.txt
                done
            done
        done
    done
done

