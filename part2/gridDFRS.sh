#!/bin/bash

p1=(0 1 2 3 4 5)
p2=(0 1)
p3=(0 1 2 3)

a=(0 0 0 0 0);
max=(0 0 0 0 0);
t_p1=(0 0 0 0 0);
t_p2=(0 0 0 0 0);
t_p3=(0 0 0 0 0);

#echo ${p1[1]}

for i in ${p1[@]}; do
    for j in ${p2[@]}; do
	for k in ${p3[@]}; do
	    java -cp "bin:lib/*" BatchSearch -index index -queries test-data/title-queries.301-450  -simfnGrid dfr ${i} ${j} ${k} > dfr_${i}_${j}_${k}.out
	    lines=$(trec_eval -m map  -m P.5,10 -m ndcg_cut.5,10  test-data/qrels.trec6-8.nocr dfr_${i}_${j}_${k}.out | awk '{print $3}')
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
		    t_p1[$m]=$i
		    t_p2[$m]=$j
		    t_p3[$m]=$k
		fi
	    done
	done
    done
done

echo "max values of map p5 p10 ndcg5 ndcg10"
echo "${max[0]} ${max[1]} ${max[2]} ${max[3]} ${max[4]}"
echo "(p1, p2, p3) values"
echo "(${t_p1[0]},${t_p2[0]},${t_p3[0]}) (${t_p1[1]},${t_p2[1]},${t_p3[1]}) (${t_p1[2]},${t_p2[2]},${t_p3[2]}) (${t_p1[3]},${t_p2[3]},${t_p3[3]}) (${t_p1[4]},${t_p2[4]},${t_p3[4]})"
