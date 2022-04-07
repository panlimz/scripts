-- Insert operação disponível
insert into monitor.operacao_disponivel (
especie, id_operacao_disponivel, id_produto, nome, prefixo, tipo_operacao)
values 
	(false, 101, 1, 'COMP A/V-SOL DISP C/CLI-R$ ANT VENC', 'CCAV', 1),
	(false, 102, 1, 'COMPRA A/V - INT$ - APRES', 'COIA', 1),
	(false, 103, 1, 'COMPRA A/V - R$ - APRES', 'CORA', 1),
	(false, 104, 1, 'CPP LOJISTA TRF P/FATURA - REAL', 'CLFR', 1),
	(true, 105, 1, 'SAQUE MANUAL-CARTOES BB NA AGENCIA', 'SQMA', 1),
	(true, 106, 1, 'SAQUE BB B24HORAS-SOL C/CLIENTE', 'SQCC', 1),
	(true, 107, 1, 'SAQUE - INT$ - APRES', 'SQIA', 1),
	(true, 108, 1, 'SAQUE CASH/ATM BB', 'SQCE', 1),
	(false, 201, 2, 'RECEBIMENTO SALARIO', 'RSSV', 2)

select * from monitor.operacao_disponivel od 

