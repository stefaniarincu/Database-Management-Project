--12. Definiti un trigger de tip LDD. Declansati trigger-ul.

/*
    Vrem sa creem un tabel de istoric actiuni din baza de date, in care vom introduce date corespunzatoare folosindu-ne de un trigger de tip LDD.
*/

CREATE TABLE istoric_actiuni_bd
    (nume_bd VARCHAR2(50),
     user_logat VARCHAR2(30),
     eveniment VARCHAR2(20),
     tip_obiect_referit VARCHAR2(30),
     nume_obiect_referit VARCHAR2(30),
     data TIMESTAMP(3));

CREATE OR REPLACE TRIGGER trig_proiect_ex12_rs
    AFTER ALTER OR DROP OR CREATE ON SCHEMA
BEGIN
    INSERT INTO istoric_actiuni_bd
    VALUES (SYS.DATABASE_NAME, SYS.LOGIN_USER, 
            SYS.SYSEVENT, SYS.DICTIONARY_OBJ_TYPE, 
            SYS.DICTIONARY_OBJ_NAME, SYSTIMESTAMP(3));
END trig_proiect_ex12_rs;
/

SELECT * FROM ISTORIC_ACTIUNI_BD;

DROP TRIGGER trig_proiect_ex12_rs;