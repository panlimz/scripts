#!/bin/bash
#Manipulating data between CSV files and PostgreSQL

#Download, extract and remove .zip files
function downzip () {
	for y in {17..21}
	do
		for m in {01..12}
		do
			#Downloading file
			wget --read-timeout=5 -P /home/paloma/Bootcamp/SQL/Data/CPGF "https://www.portaltransparencia.gov.br/download-de-dados/cpgf/20$y$m"
			#Unziping file
			unzip /home/paloma/Bootcamp/SQL/Data/CPGF/20$y$m -d /home/paloma/Bootcamp/SQL/Data/CPGF
			#Deleting zip file		
			rm /home/paloma/Bootcamp/SQL/Data/CPGF/20$y$m
		done
	done
	echo "Arquivos baixados e extraídos com sucesso. Seus .ZIP foram removidos."
}

#Populate temp table with data 
function copy_data_totemp () {
	#Creating new tables
	PGPASSWORD=123456 psql -U paloma -d bctest --c "
	drop table if exists public."tmp_cpgf";
		CREATE TABLE public."tmp_cpgf" (
			"codigo_orgao_superior" integer NULL,
			"nome_orgao_superior" varchar(1024) NULL,
			"codigo_orgao" integer NULL,
			"nome_orgao" varchar(1024) NULL,
			"codigo_unidade_gestora" integer NULL,
			"nome_unidade_gestora" varchar(1024) NULL,
			"ano" integer NULL,
			"mes" integer NULL,
			"cpf_portador" varchar(1024) NULL,
			"nome_portador" varchar(1024) NULL,
			"documento_favorecido" varchar(1024) NULL,
			"nome_favorecido" varchar(1024) NULL,
			"transacao" varchar(1024) NULL,
			"data" varchar(1024) NULL,
			"valor" varchar(1024) NULL
		);

	drop table if exists public."final_cpgf";
		CREATE TABLE public."final_cpgf" (
			"codigo_orgao_superior" integer NULL,
			"nome_orgao_superior" varchar(1024) NULL,
			"codigo_orgao" integer NULL,
			"nome_orgao" varchar(1024) NULL,
			"codigo_unidade_gestora" integer NULL,
			"nome_unidade_gestora" varchar(1024) NULL,
			"ano" integer NULL,
			"mes" integer NULL,
			"cpf_portador" varchar(1024) NULL,
			"nome_portador" varchar(1024) NULL,
			"documento_favorecido" varchar(1024) NULL,
			"nome_favorecido" varchar(1024) NULL,
			"transacao" varchar(1024) NULL,
			"data" date NULL,
			"valor" decimal(20,2) NULL
		);"
	#Copying data to tmp table	
	for y in {17..21}
	do
		for m in {01..12}
		do
			PGPASSWORD=123456 psql -U paloma -d bctest -c "\copy tmp_cpgf from '/home/paloma/Bootcamp/SQL/Data/CPGF/20${y}${m}_CPGF.csv' csv header delimiter ';' encoding 'latin1'"
		done
	done
	echo "Dados copiados com sucesso para a tabela temporária."
}

#Update tmp table
function update_tmp () {
	PGPASSWORD=123456 psql -U paloma -d bctest -c "
	update tmp_cpgf 
		set valor = replace(valor, ',', '.')
		where valor is not null"
}

#Insert tmp data to final table
function load_data_tofinal () {
	psql -U paloma -d bctest --c "
		update tmp_cpgf 
			set valor = replace(valor, ',', '.')
			where valor is not null;
		insert into final_cpgf 
			(codigo_orgao_superior, nome_orgao_superior, codigo_orgao, nome_orgao, codigo_unidade_gestora, 
			nome_unidade_gestora, ano, mes, cpf_portador, nome_portador, documento_favorecido, 
			nome_favorecido, transacao, "data", valor)
		SELECT 
			codigo_orgao_superior, nome_orgao_superior, codigo_orgao, nome_orgao, codigo_unidade_gestora, 
			nome_unidade_gestora, ano, mes, cpf_portador, nome_portador, documento_favorecido, 
			nome_favorecido, transacao, TO_DATE(data, 'DD/MM/YYYY'), cast(valor as decimal(20,2))
		FROM tmp_cpgf;
		truncate table tmp_cpgf;"
	echo "Dados carregados com sucesso para a tabela final e tabela temporária limpa."
}

#Interactive loop with PS3
cmds='downzip copy_data_totemp update_tmp load_data_tofinal Quit'
PS3='Select command: '
select cmd in $cmds
do
	if [ $cmd == 'Quit' ] 
		then break
	elif [[ "$cmd" == "downzip" ]]; then
		downzip
	elif [[ "$cmd" == "copy_data_totemp" ]]; then
		copy_data_totemp
	elif [[ "$cmd" == "update_tmp" ]]; then
		update_tmp
	elif [[ "$cmd" == "load_data_tofinal" ]]; then
		load_data_tofinal
	else
		echo "Comando não encontrado."
	fi
done
echo 'Fim do script'
