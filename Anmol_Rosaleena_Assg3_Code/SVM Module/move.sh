i=0
for x in *; do
  if [ "$i" = 100 ]; then break; fi
  mv -- "$x" ../train
  i=$((i+1))
done
