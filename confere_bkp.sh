#!/bin/bash
#################################################################
#Script Name: conferebackup.sh                                  #
#Description: Script para automação da conferencia do backup    #
#Args:                                                          #
#Author:Julio Cesar Vieira                                      #
#Email: julio@guivi.com.br                                      #
#################################################################
#Declarações de variaveis
DEST="/mnt/backup"
vdata=$(date '+%Y%m%d')
ontem=$(date -d '1 day ago' +%Y/%m/%d)
ontemsb=$(date -d '1 day ago' +%Y%m%d)
log="/tmp/$ontemsb.log"

## Email
SEND_EMAIL="/usr/bin/sendEmail -o tls=no"
MENSAGEM=$log
FROM=""
PASS=""
TO=""
CC=""
SMTP=""
PORT=""


## Testa ponto de montagem
testa_mtg(){
if [ -d $DEST/$ontem ];then
        touch $log
        echo "--------------------------------------------------" >> $log
        echo "Diretorio existente no dia $ontemsb" >> $log
        echo "Tamanho do Backup" >> $log
        du -sch $DEST/$ontem/* >> $log
        echo "--------------------------------------------------"  >> $log
        echo "Tamanho dos diretorios originais $vdata" >> $log
        du -sch /etc >> $log
        du -sch /home >> $log
        du -sch /var >> $log
        echo "--------------------------------------------------"  >> $log
else
        echo "diretorio não existe backup não foi feito $ontemsb"
        echo "--------------------------------------------------"  >> $log
        echo "Tamanho dos diretorios originais no dia $vdata" >> $log
        du -sch /etc >> $log
        du -sch /home >> $log
        du -sch /var >> $log
        echo "--------------------------------------------------"  >> $log
fi
}

envia_email(){
 $SEND_EMAIL -f ${FROM} -t ${TO} -cc ${CC} -u "Verificacao diaria de backup em $vdata referente ao dia de $ontemsb - `hostname -a`" -o message-file=$MENSAGEM -xu ${FROM} -xp ${PASS} -s ${SMTP}:${PORT} && exit

}
limpa_log (){
        rm -rf $log
}

testa_mtg
envia_email
limpa_log
