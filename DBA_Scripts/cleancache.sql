
--[ NAO REALIZAR VISTO EM PROD VISTO QUE LIMPA INFO EM MEMORIA]
--1. Abrir task manager e verificar uso de cpu, memoria e disco
--2. abrir ssms e conectar base de dados
--3. Executar :

DBCC DROPCLEANBUFFERS  -- vamos limpar os dados que estao em cache. Nao faça isto em producao.
DBCC FREEPROCCACHE
GO 
    