-- Exercícios de consulta

-- 1. Identificar 'pessoas' (portador) que movimentaram em espepécie (Saques) mais do que 20 mil reais em espécie.
select 
	cpf_portador, nome_portador, ano, mes,
	max(valor) as maior_valor_saque,
	min(valor) as menor_valor_saque,
	count(*) as qtd_movimentacoes,
	sum(valor) as valor_total
from 
	final_cpgf 
where 
	transacao like 'SAQUE%'  
group by 
	cpf_portador, nome_portador, ano, mes
having 
	sum(valor) > 20000
order by
	nome_portador, ano, mes

-- 2. Identificar 'pessoas' (portador) que movimentaram em um único dia em espécie (saques) mais do que 5 mil reais.
select 
	cpf_portador, nome_portador, "data",
	max(valor) as maior_valor_saque,
	min(valor) as menor_valor_saque,
	count(*) as qtd_movimentacoes,
	sum(valor) as valor_total
from 
	final_cpgf 
where 
	transacao ilike 'Saque%'  
group by 
	cpf_portador, nome_portador, "data"
having 
	sum(valor) > 5000
order by
	nome_portador

-- 3. Qual o orgão que fez pelo menos 100 movimentações sigilosas dentro de um mês com valor exatamente igual a 1000 reais.
select 
	codigo_orgao, nome_orgao, mes, ano,
	count(*) as qtd_movimentacoes,
	sum(valor) as valor_total 
from 
	final_cpgf
where 
	transacao ilike 'Informações protegidas%'
group by 
	codigo_orgao, nome_orgao, mes, ano, valor 
having 
	count(*) > 100 and valor = 1000
order by 
	codigo_orgao, nome_orgao, ano, mes

-- 4. Qual o orgão que fez pelo menos 100 mil reais em movimentações sigilosas dentro de um mês com valor multiplo de 100 reais.
select 
	codigo_orgao, nome_orgao, mes, ano,
	count(*) as qtd_movimentacoes,
	sum(valor) as valor_total 
from 
	final_cpgf
where 
	transacao ilike 'Informações protegidas%' and valor % 100 = 0
group by
	codigo_orgao, nome_orgao, mes, ano, valor 
having 
	sum(valor) >= 100000
order by 
	nome_orgao, ano, mes

-- 5. Quantas pessoas usaram o cartão e são PEPs ? e quantas pessoas usaram o cartão e não são PEP?
-- PEPs que usaram o cartão = 13 pessoas
--select count (*) as total_peps_cartao 
--from (
	select 
		distinct on (nome_pep) nome_pep as pep_com_cpgf, cpf
	from 
		final_pep 
	where (nome_pep, cpf) in (select nome_portador, cpf_portador from final_cpgf)
--	) as peps
	
-- Pessoas que usaram o cartão e não são PEP = 10732
--select count (*) as ports_nao_pep
--from (
	select 
		distinct nome_portador as portador_nao_pep, cpf_portador 
	from final_cpgf
	except
	select 
		nome_pep, cpf 
	from final_pep
--	) as nao_peps

-- 6. identificar pessoas que receberam (remuneracao servidores) mais do que 500 mil em 2021 ? Soma real mais dollar, assuma o valor do dollar como R$ 5,40 e quais os seus orgãos.
select 
	* 
from ( 
select 
	fsr.id_servidor_portal,
	fs2.nome,
	fs2.cpf,
	fs2.cod_org_lotacao,
	fs2.org_lotacao,
	sum("total_rem_(R$)") + sum("total_rem_(U$)")*5.4  as total_reais
from 
	final_serv_siape_rem fsr
inner join	
	final_serv_siape_cad fs2
	on fs2.id_servidor_portal = fsr.id_servidor_portal 
group by 
	fsr.id_servidor_portal,
	fs2.nome,
	fs2.cpf,
	fs2.cod_org_lotacao,
	fs2.org_lotacao 
having
	sum("total_rem_(R$)") + sum("total_rem_(U$)")*5.4 > 500000
) servidor_rem_total 

-- 7. Identificar pessoas que receberam (remuneração servidores) mais do que 500 mil em 2021 apenas em moeda estrangeira.

select 
	* 
from ( 
select 
	fsr.id_servidor_portal,
	fs2.nome,
	fs2.cpf,
	fs2.cod_org_lotacao,
	fs2.org_lotacao,
	SUM("total_rem_(U$)")*5.4  as total_US_conv
from 
	final_serv_siape_rem fsr
inner join	
	final_serv_siape_cad fs2
	on fs2.id_servidor_portal = fsr.id_servidor_portal 
group by 
	fsr.id_servidor_portal,
	fs2.nome,
	fs2.cpf,
	fs2.cod_org_lotacao,
	fs2.org_lotacao 
having
	SUM("total_rem_(U$)")*5.4 > 500000
) as serv_dol

-- 8. Há PEPs dentro do conjunto 6 ? Quais?
select 
	* 
from ( 
select 
	fsr.id_servidor_portal,
	fs2.nome,
	fs2.cpf,
	fs2.cod_org_lotacao,
	fs2.org_lotacao,
	sum("total_rem_(R$)") + sum("total_rem_(U$)")*5.4  as total_reais
from 
	final_serv_siape_rem fsr
inner join	
	final_serv_siape_cad fs2
	on fs2.id_servidor_portal = fsr.id_servidor_portal 
group by 
	fsr.id_servidor_portal,
	fs2.nome,
	fs2.cpf,
	fs2.cod_org_lotacao,
	fs2.org_lotacao 
having
	sum("total_rem_(R$)") + sum("total_rem_(U$)")*5.4 > 500000
) servidor_rem_total 
where 
	exists ( select 1 from final_pep fp where servidor_rem_total.cpf = fp.cpf and servidor_rem_total.nome = fp.nome_pep);