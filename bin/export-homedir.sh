#!/bin/bash
# Exports select files from my home directory to a specified folder (passed in
# arg)

out_folder=$1

if [ ! -d $out_folder ]; then
    mkdir $out_folder
fi
if [ ! -d $out_folder/bin ]; then
    mkdir $out_folder/bin
fi

#copy main files
OUT[1]=`echo ~/.vim/`
OUT[2]=`ls ~/.vimrc`
OUT[3]=`ls ~/.bash_pro*`
OUT[4]=`ls ~/.bashrc`
OUT[5]=`ls ~/.django_*`
OUT[6]=`ls ~/.gitconfig`
OUT[7]=`ls ~/.inputrc`
OUT[8]=`ls ~/.screenrc`
OUT[9]=`ls ~/.svn_bash*`
OUT[10]=`ls ~/.bash_a*`
OUT[11]=`ls ~/.bash_log*`

for ((i=1; i<=${#OUT[@]}; i++))
    do 
        # echo ${OUT[$i]}
        cp -R -v -f ${OUT[$i]} ${out_folder}
    done

#rename vimrc for github highlighting
mv $out_folder/.vimrc $out_folder/.vimrc.vim

#copy bin/ specific files
OUT[12]=`ls ~/bin/colors`
OUT[13]=`ls ~/bin/cronic`
OUT[14]=`ls ~/bin/emailmyip`
OUT[15]=`ls ~/bin/ssh-copy-id`
OUT[16]=`ls ~/bin/export*`
OUT[17]=`ls ~/bin/svnvimdiff`

for ((i=12; i<=${#OUT[@]}; i++))
    do 
        # echo ${OUT[$i]}
        cp -R -v -f ${OUT[$i]} ${out_folder}/bin
    done
