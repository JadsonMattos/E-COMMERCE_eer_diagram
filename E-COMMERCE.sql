create database ecommerce;
use ecommerce;

create table client(
    idClient int auto_increment primary key,
    Pname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(30),
    constraint unique_cpf_client unique (CPF)
);

create table product(
    idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids bool default false,
    category enum('eletrônico', 'vestuário', 'alimento', 'brinquedo', 'livro', 'outro') not null,
    avaliação float default 0,
    size varchar(10),
    constraint unique_cpf_client unique (CPF)
);

create table order(
    idOrder int auto_increment primary key,
    idOrderClient int not null,
    idPayment int not null,
    orderStatus enum('Cancelado', 'Em andamento', 'Entregue') default 'Em andamento',
    orderDescription varchar(100),
    sendValue float defaul 10,
    paymentCash boolean deafult false,
    constraint fk_client_order foreign key (idOrderClient) references client(idClient)
        on update cascade,
    constraint fk_payment_order foreign key (idPayment) references payment(idPayment)
);

create table payment(
    idPayment int auto_increment primary key,
    idPaymentClient int not null,
    paymentStatus enum('Aprovado', 'Pendente', 'Recusado') not null,
    paymentValue float not null,
    typePayment enum('Cartão de crédito', 'Cartão de débito', 'Boleto', 'Pix', 'Dinheiro') not null,
    limitAvailable float,
    constraint fk_client_payment foreign key (idPaymentClient) references client(idClient),
);

create table productStorage(
    idProductStorage int auto_increment primary key,
    storageLocation varchar(10),    
    quantity int default 0,
);

create table supplier(
    idSupplier int auto_increment primary key,
    supplierName varchar(20) not null,
    supplierCNPJ char(15) not null,
    supplierContact varchar(20) not null,
    constraint unique_cnpj_supplier unique (supplierCNPJ)
);

create table seller(
    idSeller int auto_increment primary key,
    sellerName varchar(20) not null,
    AbstractName varchar(20),
    sellerCNPJ char(15),
    sellerCPF char(11),
    location varchar(20),
    sellerContact varchar(20) not null,
    constraint unique_cnpj_seller unique (sellerCNPJ),
    constraint unique_cpf_seller unique (sellerCPF)
);

create table productSeller(
    idProductSeller int,
    idProduct int,
    idSeller int not null,
    productQuantity int deafult 1,
    primary key (idProductSeller, idProduct, idSeller),
    constraint fk_product_productSeller foreign key (idProduct) references product(idProduct),
    constraint fk_seller_productSeller foreign key (idSeller) references seller(idSeller)
);

create table productOrder(
    idProductOrder int,
    idProduct int,
    idOrder int not null,
    productQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idProductOrder, idProduct, idOrder),
    constraint fk_product_productOrder foreign key (idProduct) references product(idProduct),
    constraint fk_order_productOrder foreign key (idOrder) references order(idOrder)
);

create table storageLocation(
    idProduct int,
    idStorageLocation int,
    storageLocation varchar(10) not null,
    idProductStorage int not null,
    primary key (idStorageLocation, idProduct, idProductStorage),
    constraint fk_product_storageLocation foreign key (idProduct) references product(idProduct),
    constraint fk_productStorage_storageLocation foreign key (idProductStorage) references productStorage(idProductStorage)
);

create table productSupplier(
    idProductSupplier int,
    idProduct int,
    idSupplier int not null,
    productQuantity int default 1,
    primary key (idProductSupplier, idProduct, idSupplier),
    constraint fk_product_productSupplier foreign key (idProduct) references product(idProduct),
    constraint fk_supplier_productSupplier foreign key (idSupplier) references supplier(idSupplier)
);

INSERT INTO client (Pname, Minit, Lname, CPF, Address) VALUES
('Ana', 'M', 'Silva', '12345678901', 'Rua A, 100'),
('João', 'P', 'Souza', '23456789012', 'Rua B, 200'),
('Maria', 'F', 'Oliveira', '34567890123', 'Rua C, 300');

INSERT INTO product (Pname, classification_kids, category, avaliação, size) VALUES
('Notebook', FALSE, 'eletrônico', 4.8, 'Médio'),
('Camiseta', FALSE, 'vestuário', 4.5, 'G'),
('Boneca', TRUE, 'brinquedo', 4.2, 'Pequeno');

INSERT INTO payment (idPaymentClient, paymentStatus, paymentValue, typePayment, limitAvailable) VALUES
(1, 'Aprovado', 2500.00, 'Cartão de crédito', 5000.00),
(2, 'Pendente', 100.00, 'Boleto', NULL),
(3, 'Recusado', 150.50, 'Pix', NULL);

INSERT INTO orders (idOrderClient, idPayment, orderStatus, orderDescription, sendValue, paymentCash) VALUES
(1, 1, 'Em andamento', 'Compra de notebook', 20.0, FALSE),
(2, 2, 'Cancelado', 'Compra de camiseta', 10.0, TRUE),
(3, 3, 'Entregue', 'Compra de boneca', 15.0, FALSE);

INSERT INTO productStorage (storageLocation, quantity) VALUES
('Estoque A', 50),
('Estoque B', 200),
('Estoque C', 75);

INSERT INTO supplier (supplierName, supplierCNPJ, supplierContact) VALUES
('Fornecedor 1', '12345678900001', '(11) 1234-5678'),
('Fornecedor 2', '23456789000012', '(11) 2345-6789'),
('Fornecedor 3', '34567890100023', '(11) 3456-7890');

INSERT INTO seller (sellerName, AbstractName, sellerCNPJ, sellerCPF, location, sellerContact) VALUES
('Vendedor A', 'Loja A', '11111111100011', NULL, 'Rua X', '(11) 9876-5432'),
('Vendedor B', 'Loja B', NULL, '12345678901', 'Rua Y', '(11) 8765-4321'),
('Vendedor C', 'Loja C', '22222222200022', NULL, 'Rua Z', '(11) 7654-3210');

INSERT INTO productSeller (idProductSeller, idProduct, idSeller, productQuantity) VALUES
(1, 1, 1, 10),
(2, 2, 2, 50),
(3, 3, 3, 30);

INSERT INTO productOrder (idProductOrder, idProduct, idOrder, productQuantity, poStatus) VALUES
(1, 1, 1, 1, 'Disponível'),
(2, 2, 2, 2, 'Sem estoque'),
(3, 3, 3, 1, 'Disponível');

INSERT INTO storageLocation (idProduct, idStorageLocation, storageLocation, idProductStorage) VALUES
(1, 1, 'Estoque A', 1),
(2, 2, 'Estoque B', 2),
(3, 3, 'Estoque C', 3);

INSERT INTO productSupplier (idProductSupplier, idProduct, idSupplier, productQuantity) VALUES
(1, 1, 1, 20),
(2, 2, 2, 100),
(3, 3, 3, 50);
