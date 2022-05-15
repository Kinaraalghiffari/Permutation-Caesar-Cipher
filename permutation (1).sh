#!/bin/sh

echo "silahkan input file txt : "
read input

echo "Masukkan nama file yang akan ingin dimasukkan hasil ciphernya : "
read filehasilcipher

#membaca array urutan key
echo "input urutan key : "
read -a urutan
echo -e "Urutan key : ${urutan[@]}"
jumlahkey=${#urutan[@]}
seen=()

#Mengecek apakah didalam urutan key terdapat duplikat
for i in "${urutan[@]}"; do
    if [ -z "${seen[i]}" ]; then
        seen[i]=1
        duplikat="false"
    else
        echo "Array mempunyai duplikat"
        duplikat="true"
        break
    fi
done
echo "Apakah urutan key mempunyai duplikat : ${duplikat}"

#Apabila urutan key tidak mempunyai duplikat maka dapat tercipher
if [[ ${duplikat} == "true" ]]
  then
     echo " "
     echo "=== TIDAK DAPAT TERENKRIPSI ==="
     echo " "

  else
     #membaca file plain text dan cipher text
     while IFS= read -r file; do

        jumlahcharacter=${#file}
        penjumlahsplit=$(( $jumlahkey - 1 ))
        echo "Jumlah Character : $jumlahcharacter"

        #Mengecek apakah karakter dapat termodulo dengan jumlah key
        #Apabila dapat tersisa dari modulo maka akhir kalimat ditambahkan (-) sesuai sisa modulo

         if [ $((jumlahcharacter%jumlahkey)) -ne 0 ]
           then
               echo "==== split tidak sesuai dengan pambagian blok sehingga terdapat karakter yang ditambahkan - ==== "
               modulo=$((jumlahcharacter%jumlahkey))
               looping=$((jumlahkey-modulo))
               filecipher=$file

               for (( i=0 ; i < $looping ; i++ ))
                 do
                   filecipher=${filecipher:0:${#filecipher}}-
               done

               for (( j=0 ; j < ${#filecipher} ; j++ ))
                 do
                   array[$j]=${filecipher:j:$jumlahkey}
                   (( j = j + $penjumlahsplit ))
               done
               echo " HASIL PEMISAHAN SESUAI DENGAN BLOK PER ${jumlahkey} KARAKTER "
               printf "%s*" "${array[@]}"
          else
              echo " TIDAK TERDAPAT PENAMBAHAN KARAKTER KARENA TIDAK MEMILIKI SISA DARI MODULO "
              for (( i=0 ; i < ${#file} ; i++ ))
                do
                  array[$i]=${file:i:$jumlahkey}
                  (( i = i + $penjumlahsplit ))
              done
              printf "%s*" "${array[@]}"
          fi



        # Melakukan proses cipher dengan permutasi
        for (( i=0 ; i < ${#file} ; i++ ))
          do
            kata=${array[i]}
            jumlah=${#array[i]}
            (( i = i + $penjumlahsplit ))
              for (( j=0 ; j < $jumlah ; j++ ))
                 do
                   arr[$j]=${kata:$j:1}
              done

              for (( c=0 ; c < ${#urutan[@]} ; c++ ))
                 do
                   ciphered[$c]=${arr[urutan[c]]}
              done
            cipher[$i]=$( printf "%s" "(**)" "${ciphered[@]}")
         done


   echo " "
   echo "=== HASIL CIPHER ==="
   echo "${cipher[@]}"
   echo " "
   done < $input
   echo "${cipher[@]}" > $filehasilcipher

fi