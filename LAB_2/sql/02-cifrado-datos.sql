--ACT 02
--haremos una tabla para testear
CREATE TABLE clientes_protegidos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    rfc_cifrado BYTEA NOT NULL
);

--haremos una inserccion con cifrado simetrico
INSERT INTO clientes_protegidos (
    nombre,
    rfc_cifrado
)
VALUES (
    'Ana López',
    pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA')
);

--revisemos se haya insertado bien los datos
SELECT * FROM clientes_protegidos;

--recuperamos el dato para poder ver el rfc y dinde la clave es equivocada
SELECT
    id,
    nombre,
    pgp_sym_decrypt(
        rfc_cifrado,
        'CLAVE-DE-PRUEBA'
    ) AS rfc
FROM clientes_protegidos;

SELECT pgp_sym_decrypt(rfc_cifrado, 'CLAVE-EQUIVOCADA')
FROM clientes_protegidos;
