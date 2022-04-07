-- Sequencia
create sequence proc_contrato_sequence start with 1;
drop sequence proc_contrato_sequence;
truncate table monitor.proc_contrato 

-- Insert proc_contrato 
insert into monitor.proc_contrato (
	categoria, codigo, documento_contraparte, dt_entrada, dt_vencimento, id_proc_cliente, id_proc_contrato, id_produto, moeda, nome_contraparte, 
	outros, pais, produto, relacionado, relacionamento, status, valor, valor_entrada, valor_mensal)
select null, pc.codigo, null, pc.dt_entrada, null, pc.id_proc_cliente, (nextval('proc_contrato_sequence')), 
(pr.id_produto), null, null, '{}', null, null, null, null, null, null, null, null
from monitor.proc_cliente pc 
join monitor.produto pr on
case when pc.codigo like 'CPGF_%' then pr.id_produto = 1 else pr.id_produto = 2
end

select * from monitor.proc_contrato pc 

select * from monitor.proc_cliente pc 