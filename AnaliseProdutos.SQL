CREATE TABLE Produtos (
    ProdutoID INT PRIMARY KEY,
    Nome VARCHAR(50),
    Categoria VARCHAR(30),
    Preco DECIMAL(10,2),
    Estoque INT
);

CREATE TABLE Vendas (
    VendaID INT PRIMARY KEY,
    ProdutoID INT,
    Quantidade INT,
    DataVenda DATE,
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);

INSERT INTO Vendas (VendaID, ProdutoID, Quantidade, DataVenda) VALUES
(1, 1, 10, '2025-08-01'),
(2, 3, 5, '2025-08-02'),
(3, 5, 3, '2025-08-02'),
(4, 2, 20, '2025-08-03'),
(5, 6, 2, '2025-08-03'),
(6, 8, 1, '2025-08-04'),
(7, 1, 5, '2025-08-04'),
(8, 9, 1, '2025-08-04'),
(9, 7, 15, '2025-08-05'),
(10, 4, 10, '2025-08-05'),
(11, 1, 15, '2025-08-06'),
(12, 2, 11, '2025-08-06'),
(13, 3, 4, '2025-08-06'),
(14, 4, 7, '2025-08-06'),
(15, 5, 6, '2025-08-06'),
(16, 6, 10, '2025-08-06'),
(17, 2, 20, '2025-08-06');





CREATE TABLE Fornecedores (
    FornecedorID INT PRIMARY KEY,
    NomeFornecedor VARCHAR(50)
);

CREATE TABLE ProdutosFornecidos (
    ProdutoID INT,
    FornecedorID INT,
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID),
    FOREIGN KEY (FornecedorID) REFERENCES Fornecedores(FornecedorID)
);


INSERT INTO Fornecedores (FornecedorID, NomeFornecedor) VALUES
(1, 'Distribuidora Central'),
(2, 'InfoTech Ltda'),
(3, 'Papelaria Brasil'),
(4, 'Acessórios Silva');

INSERT INTO ProdutosFornecidos (ProdutoID, FornecedorID) VALUES
(1, 3),
(2, 3),
(3, 3),
(4, 3),
(5, 2),
(6, 2),
(7, 3),
(8, 2),
(9, 4),
(10, 4);

-- Inserção dos dados
INSERT INTO Produtos (ProdutoID, Nome, Categoria, Preco, Estoque) VALUES
(1, 'Caneta Azul', 'Papelaria', 2.50, 120),
(2, 'Lápis Preto', 'Papelaria', 1.75, 300),
(3, 'Caderno 100p', 'Papelaria', 12.00, 150),
(4, 'Cola Branca', 'Papelaria', 3.90, 80),
(5, 'Mouse USB', 'Informática', 35.00, 40),
(6, 'Teclado ABNT', 'Informática', 50.00, 35),
(7, 'Régua 30cm', 'Papelaria', 2.00, 200),
(8, 'Pen Drive 16', 'Informática', 25.00, 75),
(9, 'Mochila X', 'Acessórios', 120.00, 22),
(10, 'Estojo Simp', 'Acessórios', 10.00, 50);

select * from Vendas as V
select * from Produtos as P
select * from Fornecedores as F
select * from ProdutosFornecidos as PF

--Total de vendas por categoria
select P.Categoria ,
	   SUM(V.Quantidade) as totalVendido
from 
	Produtos as P
JOIN
	Vendas as V
On
	V.ProdutoID = P.ProdutoID
GROUP BY
	P.Categoria
ORDER BY 
	P.Categoria DESC
	

--Produtos com alta média de venda
select TOP 5 P.Nome ,
			 P.Categoria ,
			 SUM(V.Quantidade) as SomaVenda
FROM
	Produtos as P
JOIN
	Vendas as V
ON 
	V.ProdutoID = P.ProdutoID
GROUP BY 
	P.Nome , P.Categoria
ORDER BY
	SomaVenda DESC

	
--Produtos sem vendas
select P.Nome , 
	   V.quantidade
FROM
	Produtos as P
LEFT JOIN
	Vendas as V
On
	P.ProdutoID = V.ProdutoID
where V.Quantidade is NULL


--Produtos e fornecedores mais caros
select F.NomeFornecedor ,
       p.Nome ,
	   p.Preco
From
	Fornecedores as F
JOIN 
	ProdutosFornecidos as PF
ON
	pf.FornecedorID = f.FornecedorID
JOIN
	Produtos as P
ON
	PF.ProdutoID = P.ProdutoID
where p.Preco > 30
ORDER BY p.Preco DESC



--Análise de vendas por dia
select V.DataVenda ,
       SUM(V.Quantidade) as totalVenda ,
	   COUNT(V.Quantidade) as ContagemVenda
from 
	Vendas as V
GROUP BY
	V.DataVenda 
ORDER BY 
	V.DataVenda ASC


--Produtos com vendas totais entre 5 e 20 unidades
select P.nome ,
       SUM(v.Quantidade) as TotalVendido
FROM
	Produtos as P
JOIN 
	Vendas as V
ON 
	V.ProdutoID = P.ProdutoID
GROUP BY
	P.Nome
HAVING SUM(V.Quantidade) BETWEEN 5 and 20
ORDER BY 
	TotalVendido DESC


--Produtos vendidos no dia 2025-08-06 com fornecedor
select P.Nome ,
	   F.NomeFornecedor ,
	   V.Quantidade ,
	   V.DataVenda 
from	
	Produtos as P
JOIN
	Vendas as V
ON
	p.ProdutoID = V.ProdutoID
JOIN
	ProdutosFornecidos as PF
on
	PF.ProdutoID = V.ProdutoID 
JOIN
	Fornecedores as F
ON
	F.FornecedorID = Pf.FornecedorID
where DataVenda = '2025-08-06'
ORDER BY V.Quantidade DESC


--Produtos por categoria e estoque
select  P.Categoria , 
        COUNT(p.Nome) as ContagemProdutos ,
		SUM(P.Estoque) as SomaEstoque ,
		AVG(P.Preco) as PrecoMedio
From
	Produtos as P
Group By
	P.Categoria


--Produtos com estoque baixo e alta venda
select P.Nome ,
       P.Estoque ,
	   SUM(V.Quantidade) as TotalVendido 
FROM 
	Produtos as P
JOIN 
	Vendas as V
ON
	V.ProdutoID = P.ProdutoID
where P.Estoque < 50
GROUP BY
	P.Nome ,
	P.Estoque
HAVING SUM(v.Quantidade) > 10