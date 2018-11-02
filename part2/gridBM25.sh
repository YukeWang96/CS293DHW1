#!/bin/bash

k=(0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2)
b=(0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1)
#k=(1.2 2)
#b=(0.75 1)

a=(0 0 0 0 0);
max=(0 0 0 0 0);
t_k=(0 0 0 0 0);
t_b=(0 0 0 0 0);

for i in ${k[@]}; do
    for j in ${b[@]}; do
	java -cp "bin:lib/*" BatchSearch -index index -queries test-data/title-queries.301-450  -simfnGrid bm25 ${i} ${j} > bm25_${i}_${j}.out
	lines=$(trec_eval -m map  -m P.5,10 -m ndcg_cut.5,10  test-data/qrels.trec6-8.nocr bm25_${i}_${j}.out | awk '{print $3}')
	ctr=0;
	for m in ${lines[@]}; do
	    a[$ctr]=$m
	    ctr=$(($ctr+1))
	done

	for m in `seq 0 $(($ctr-1))`; do
	    res=$(echo ${a[$m]}'>'${max[$m]} | bc -l)
	    if [ "$res" -gt 0 ]
	    then
		max[$m]=${a[$m]}
		t_k[$m]=$i
		t_b[$m]=$j
	    fi
	done		
    done
done

echo "max values of map p5 p10 ndcg5 ndcg10"
echo "${max[0]} ${max[1]} ${max[2]} ${max[3]} ${max[4]}"
echo "(k,b) values"
echo "(${t_k[0]},${t_b[0]}) (${t_k[1]},${t_b[1]}) (${t_k[2]},${t_b[2]}) (${t_k[3]},${t_b[3]}) (${t_k[4]},${t_b[4]})"
