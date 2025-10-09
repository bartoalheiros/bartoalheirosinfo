CREATE DATABASE clientesdb;
USE clientesdb;

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(255)
);
