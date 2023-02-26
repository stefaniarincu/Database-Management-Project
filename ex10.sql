--10. Definiti un trigger de tip LMD la nivel de comanda. Declansati trigger-ul.

/*
    Vrem sa definim un declansator care sa verifice anumite proprietati inainte de orice tip de inserare in tabela ACTOR. 
Trebuie sa verificam daca toti actorii care se afla momentan stocati in baza de date sunt inregistrati ca jucand in cel putin un 
film, daca datele despre anul de debut ale fiecarui actor sunt corecte, in concordanta cu filmele in care acesta a jucat 
(anul de debut sa nu fie mai tarziu decat cel de aparitie al filmului in care joaca) si ca datele despre numarul de premii obtinute
de fiecare actor sa fie coerente in raport cu anul de debut (50% din numarul de premii sa nu fie mai mare decat anul actual - anul de debut * 100)
*/

CREATE OR REPLACE TRIGGER trig_proiect_ex10_rs
    BEFORE INSERT ON actor
DECLARE
    cnt NUMBER;
BEGIN
    FOR i IN (SELECT COUNT(j.id_actor) cnt
              FROM actor a, joaca j
              WHERE a.id_actor = j.id_actor(+)
              GROUP BY a.id_actor) LOOP
        IF i.cnt = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Nu puteti introduce un nou actor pana cand nu aveti date despre cel putin o aparitie intr-un film pentru fiecare actor din baza de date!');
        END IF;
    END LOOP;
    
    SELECT COUNT(a.id_actor) INTO cnt
    FROM actor a, joaca j, film f
    WHERE a.id_actor = j.id_actor AND j.cod_film = f.cod_film 
          AND an_debut > an_aparitie;
    IF cnt <> 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nu puteti introduce un nou actor, deoarece in baza de date exista informatii eronate cu privire la anul de debut al unui actor sau filmele in care acesta a jucat!');
    END IF;
    
    SELECT COUNT(id_actor) INTO cnt
    FROM actor
    WHERE (to_char(SYSDATE, 'YYYY') - an_debut) * 100 < nr_premii * 0.5 ;
    IF cnt <> 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nu puteti introduce un nou actor, deoarece in baza de date exista informatii eronate cu privire la numarul de premii sau anul de debut al unui actor!');
    END IF;
END trig_proiect_ex10_rs;
/

INSERT INTO actor 
VALUES(1, 'ana', 'lugojana', 'RO', 220, 2022);
--1 row inserted

INSERT INTO actor 
VALUES(2, 'ana', 'blandiana', 'RO', 2, 2017);
--Error report -
--ORA-20002: Nu puteti introduce un nou actor pana cand nu aveti date despre cel putin o aparitie intr-un film pentru fiecare actor din baza de date!
--ORA-06512: at "C##SGBD_STEF.TRIG_PROIECT_EX10_RS", line 9
--ORA-06512: at "C##SGBD_STEF.TRIG_PROIECT_EX10_RS", line 9
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_PROIECT_EX10_RS'

INSERT INTO joaca
VALUES(1, 910, 1, 'principal');
--1 row inserted

INSERT INTO actor 
VALUES(2, 'ana', 'blandiana', 'RO', 2, 2017);
--Error report -
--ORA-20002: Nu puteti introduce un nou actor, deoarece in baza de date exista informatii eronate cu privire la numarul de premii sau anul de debut al unui actor!
--ORA-06512: at "C##SGBD_STEF.TRIG_PROIECT_EX10_RS", line 25
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_PROIECT_EX10_RS'

ROLLBACK;

INSERT INTO actor 
VALUES(1, 'ana', 'lugojana', 'RO', 2, 2020);
--1 row inserted

INSERT INTO joaca
VALUES(1, 1810, 1, 'principal');
--1 row inserted

INSERT INTO actor 
VALUES(2, 'ana', 'blandiana', 'RO', 2, 2017);
--Error report -
--ORA-20002: Nu puteti introduce un nou actor, deoarece in baza de date exista informatii eronate cu privire la anul de debut al unui actor sau filmele in care acesta a jucat!
--ORA-06512: at "C##SGBD_STEF.TRIG_PROIECT_EX10_RS", line 18
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_PROIECT_EX10_RS'

DROP TRIGGER trig_proiect_ex10_rs;