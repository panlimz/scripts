-- Criando tabela temporária de base para porcentagem de captação - evitar duplicatas
create table dossie.tmp_dossie_qa (
	cod_user numeric(20) NULL,
	id_dossie numeric(20,0) primary key,
	score numeric(29, 16) NULL
);

truncate table dossie.tmp_dossie_qa 

-- Visão Impacto: Status 5 (Comunicado ao coaf) tenha 10% de chance de ser coletado.
insert into dossie.tmp_dossie_qa 
select 
	cod_user, dt_dossie, id_dossie, score 
from 
	dossie.dossie d 
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from dossie.tmp_dossie_qa)
	and id_status_analise = 5
	and random() <=0.1;

-- Visão de Risco: Score > 100 tenha 10% de chance de ser coletado.
insert into dossie.tmp_dossie_qa 
select 
	cod_user, dt_dossie, id_dossie, score
from 
	dossie.dossie d 
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from dossie.tmp_dossie_qa)
	and score > 100
	and random() <=0.1;

-- Calda: Do restante 5%. 
insert into dossie.tmp_dossie_qa 
select 
	cod_user, dt_dossie, id_dossie, score
from 
	dossie.dossie d 
where 
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
	and id_dossie not in (select id_dossie from dossie.tmp_dossie_qa)
	and random() <=0.05;

/*Visão cobertura: Todos os Analise (cod_user), em diferentes nível de risco (score) distinct on(...)
1-alerta para score < 50
2-alerta para score entre 51 e 100
3-alerta para score > 100
* Se por acaso o analise não tiver alerta acima de 100 ou em qualquer outra faixa, não precisa ter uma escolha.
* 
* Considerando que a tmp possui dados apenas de 02/20222, o where pode ser ignorado para consulta desta tabela.*/
-- Visualização de dados
select distinct on (cod_user, alerta)
	cod_user, id_dossie, score, 
case
	when score < 50 then 'Dossiê(s) com score < que 50 detectado'
	when score >= 50 and score < 101 then 'Dossiê(s) com score > 51 e < 100 detectado'
	when score > 100 then 'Dossiê(s) com score > que 100 detectado'
	else '' end as alerta
from dossie.tmp_dossie_qa 
where
	extract(month from dt_dossie) = 2
	and extract(year from dt_dossie) = 2022	
group by score, cod_user, id_dossie 
order by cod_user, alerta, id_dossie, score desc


--- Inserindo dados equivalentes ao alerta na tabela temporária 
insert into dossie.tmp_dossie_qa (cod_user, id_dossie, score)
select cod_user, id_dossie, score 
from (
	select distinct on (cod_user, alerta)
		cod_user, id_dossie, score, 
	case
		when score < 50 then 'Dossiê(s) com score < que 50 detectado'
		when score >= 50 and score < 101 then 'Dossiê(s) com score > 51 e < 100 detectado'
		when score > 100 then 'Dossiê(s) com score > que 100 detectado'
		else '' end as alerta
	from dossie.dossie 
	where
		extract(month from dt_dossie) = 2
		and extract(year from dt_dossie) = 2022	
		and id_dossie not in (select id_dossie from dossie.tmp_dossie_qa) 
	group by score, cod_user, id_dossie 
	order by cod_user, alerta, id_dossie, score desc) as alertas

