#Com um utilizador com permissoes de admin na instancia, permite dar unlock ao user na instancia

USE [master]
GO
ALTER LOGIN [sa] WITH PASSWORD=N'PASSWORD' UNLOCK
GO