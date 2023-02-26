--11. Definiti un trigger de tip LMD la nivel de linie. Declansati trigger-ul.

/*
    Vrem sa definim un declansator care sa verifice anumite proprietati la nivel de linie inainte de o inserare, stergere 
sau updatare a unui camp ce apartine coloanei "cod_cinema", "cod_job" sau "id_superior" in tabela ANGAJAT.
    Inainte de a insera o noua persoana in tabela ANGAJAT in cazul in care dorim sa punem noua persoana pe postul de manager trebuie 
sa ne asiguram ca nu mai exista un alt manager in acel cinematograf, de asemenea, trebuie sa avem grija ca id-ul superiorului sa se
regaseasca in acelasi cinematograf ca cel ales pentru noul angajat si salariul atribuit sa se incadreze in intervalul determinat de job.
    Inainte de a sterge o valoare din tabela ANGAJAT trebuie sa updatam coloana "id_superior"  pentru subalternii sai deoarece este 
cheie externa care referentiaza o valoare din tabela ANGAJAT.
    Inainte de a updata una din liniile tabelei ANGAJAT, pentru una din coloanele precizate, trebuie sa verificam daca in 
cinematograful in care dorim sa il mutam, sau in vechiul cinematograf (depinde de coloanele asupra carora facem update), in cazul 
in care pe acel angajat dorim sa il punem pe postul de manager sau a posedat postul de manager (depinde de coloanele asupra carora 
facem update) sa nu fie mai multi manageri, de asemenea, trebuie sa avem grija ca id-ul superiorului sa se regaseasca in acelasi 
cinematograf ca cel in care se afla sau se va afla angajatul actualizat (depinde de coloanele asupra carora facem update).
    De asemenea, dupa update sau delete vrem sa modificam datele din tabela ISTORIC_LUCRU si coloana "id_superior" pentru subalternii 
angajatului curent, in functie de cazurile determinate de coloanele asupra carora facem update. In plus, pentru update trebuie 
modificate (daca este cazul) data de angajare si salariul, iar aceasta modificare se produce prin intermediul trigger-ului declarat.
*/

CREATE OR REPLACE TRIGGER trig_before_proiect_ex11_rs
    BEFORE INSERT OR DELETE OR UPDATE OF cod_cinema, cod_job, id_superior ON angajat
    FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
    cnt NUMBER;
    sal_min NUMBER;
    sal_max NUMBER;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO cnt
        FROM angajat
        WHERE cod_cinema = :NEW.cod_cinema
              AND cod_job LIKE :NEW.cod_job;
        IF :NEW.cod_job LIKE ('%MAN%') THEN
            IF cnt + 1 > 1 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Exista deja un manager in cinematograful dorit!');
            END IF;
        END IF;
        
        IF :NEW.id_superior IS NOT null THEN
            SELECT COUNT(*) INTO cnt
            FROM angajat
            WHERE cod_cinema = :NEW.cod_cinema AND cod_angajat = :NEW.id_superior;
            IF cnt = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
            END IF;
        END IF;
        
        SELECT COUNT(*) INTO cnt
        FROM job
        WHERE cod_job LIKE :NEW.cod_job;
        IF cnt <> 0 THEN
            SELECT salariu_min, salariu_max INTO sal_min, sal_max
            FROM job
            WHERE cod_job LIKE :NEW.cod_job;
            IF sal_min > :NEW.salariu THEN
                RAISE_APPLICATION_ERROR(-20002, 'Salariul este mai mic decat cel minim pentru jobul ales!');
            ELSIF sal_max < :NEW.salariu THEN
                RAISE_APPLICATION_ERROR(-20002, 'Salariul este mai mare decat cel maxim pentru jobul ales!');
            END IF;
        END IF;
    ELSIF DELETING THEN
        UPDATE angajat
        SET id_superior = :OLD.id_superior
        WHERE id_superior = :OLD.cod_angajat;
    ELSIF UPDATING('cod_cinema') AND UPDATING('cod_job') THEN
    	IF UPDATING('id_superior') THEN
            IF :NEW.id_superior IS NOT null THEN
                SELECT COUNT(*) INTO cnt
                FROM angajat
                WHERE cod_cinema = :NEW.cod_cinema AND cod_angajat = :NEW.id_superior;
                IF cnt = 0 THEN
                    RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
                END IF;
            END IF;
        END IF;
        
        SELECT COUNT(*) INTO cnt
        FROM angajat
        WHERE cod_job = :NEW.cod_job AND cod_cinema = :NEW.cod_cinema;
        IF :NEW.cod_job = 'MAN' THEN
            IF cnt + 1 > 1 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Exista deja un manager in cinematograful dorit!');
            END IF;
        END IF;
    ELSIF UPDATING('cod_cinema') THEN
    	IF UPDATING('id_superior') THEN
            IF :NEW.id_superior IS NOT null THEN
                SELECT COUNT(*) INTO cnt
                FROM angajat
                WHERE cod_cinema = :NEW.cod_cinema AND cod_angajat = :NEW.id_superior;
                IF cnt = 0 THEN
                    RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
                END IF;
            END IF;
        END IF;
        
        SELECT COUNT(*) INTO cnt
        FROM angajat
        WHERE cod_job = :OLD.cod_job AND cod_cinema = :NEW.cod_cinema;
        IF :OLD.cod_job = 'MAN' THEN
            IF cnt + 1 > 1 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Exista deja un manager in cinematograful dorit!');
            END IF;
        END IF;
	ELSIF UPDATING('cod_job') THEN
        IF UPDATING('id_superior') THEN
            IF :NEW.id_superior IS NOT null THEN
                SELECT COUNT(*) INTO cnt
                FROM angajat
                WHERE cod_cinema = :OLD.cod_cinema AND cod_angajat = :NEW.id_superior;
                IF cnt = 0 THEN
                    RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
                END IF;
            END IF;
        END IF;
                
        SELECT COUNT(*) INTO cnt
        FROM angajat
        WHERE cod_job = :NEW.cod_job AND cod_cinema = :OLD.cod_cinema;
        IF :OLD.cod_job = 'MAN' THEN
            IF cnt + 1 > 1 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Exista deja un manager in cinematograful curent!');
            END IF;
        END IF;
    ELSIF UPDATING('id_superior') THEN
        IF :NEW.id_superior IS NOT null THEN
            SELECT COUNT(*) INTO cnt
            FROM angajat
            WHERE cod_cinema = :OLD.cod_cinema AND cod_angajat = :NEW.id_superior;
            IF cnt = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!');
            END IF;
        END IF;
    END IF;
    COMMIT;
END trig_before_proiect_ex11_rs;
/

CREATE OR REPLACE TRIGGER trig_after_proiect_ex11_rs
    FOR DELETE OR UPDATE OF cod_cinema, cod_job, id_superior ON angajat
    COMPOUND TRIGGER
        TYPE rec_upd IS RECORD
            (id_ang angajat.cod_angajat%TYPE,
             id_sup angajat.id_superior%TYPE,
             v_cin angajat.cod_cinema%TYPE,
             n_cin angajat.cod_cinema%TYPE,
             v_job angajat.cod_job%TYPE,
             n_job angajat.cod_job%TYPE,
             d_ang angajat.data_ang%TYPE,
             v_sal angajat.salariu%TYPE,
             flag NUMBER);
        TYPE tab_idx_upd IS TABLE OF rec_upd INDEX BY PLS_INTEGER;  
        t_upd tab_idx_upd;
        
        TYPE tab_idx_del IS TABLE OF angajat.cod_angajat%TYPE INDEX BY PLS_INTEGER;  
        t_del tab_idx_del;
        poz NUMBER;
        sal_max NUMBER;
        sal_min NUMBER;
    AFTER EACH ROW IS
    BEGIN
        IF DELETING THEN
            poz := t_del.COUNT + 1;
            t_del(poz) := :OLD.cod_angajat; 
        ELSIF UPDATING('cod_cinema') AND UPDATING('cod_job') THEN
            poz := t_upd.COUNT + 1;
            t_upd(poz).id_ang := :OLD.cod_angajat; 
            t_upd(poz).id_sup := :OLD.id_superior; 
            t_upd(poz).v_cin := :OLD.cod_cinema; 
            t_upd(poz).d_ang := :OLD.data_ang; 
            t_upd(poz).n_cin := :NEW.cod_cinema;
            t_upd(poz).v_job := :OLD.cod_job;
            t_upd(poz).n_job := :NEW.cod_job;
            t_upd(poz).flag := 0;
            t_upd(poz).v_sal := :OLD.salariu;
            IF UPDATING('id_superior') THEN
                t_upd(poz).flag := 1;
            END IF;
        ELSIF UPDATING('cod_cinema')THEN
            poz := t_upd.COUNT + 1;
            t_upd(poz).id_ang := :OLD.cod_angajat; 
            t_upd(poz).id_sup := :OLD.id_superior; 
            t_upd(poz).v_cin := :OLD.cod_cinema; 
            t_upd(poz).d_ang := :OLD.data_ang; 
            t_upd(poz).n_cin := :NEW.cod_cinema;
            t_upd(poz).v_job := :OLD.cod_job;
            t_upd(poz).v_sal := :OLD.salariu;
            t_upd(poz).flag := 0;
            t_upd(poz).n_job := :OLD.cod_job;
            IF UPDATING('id_superior') THEN
                t_upd(poz).flag := 1;
            END IF;
        ELSIF UPDATING('cod_job') THEN
            poz := t_upd.COUNT + 1;
            t_upd(poz).id_ang := :OLD.cod_angajat; 
            t_upd(poz).id_sup := :OLD.id_superior; 
            t_upd(poz).v_cin := :OLD.cod_cinema; 
            t_upd(poz).d_ang := :OLD.data_ang; 
            t_upd(poz).n_cin := :OLD.cod_cinema;
            t_upd(poz).v_job := :OLD.cod_job;
            t_upd(poz).v_sal := :OLD.salariu;
            t_upd(poz).n_job := :NEW.cod_job;
            t_upd(poz).flag := 1;
        END IF;
    END AFTER EACH ROW;
    
    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1..t_del.COUNT LOOP            
            DELETE FROM istoric_lucru
            WHERE cod_angajat = t_del(i);
        END LOOP;
        FOR i IN 1..t_upd.COUNT LOOP
            IF t_upd(i).v_cin <> t_upd(i).n_cin THEN
                UPDATE angajat
                SET id_superior = t_upd(i).id_sup
                WHERE id_superior = t_upd(i).id_ang;
                IF t_upd(i).flag = 0 THEN    
                    UPDATE angajat
                    SET id_superior = null
                    WHERE cod_angajat = t_upd(i).id_ang;
                END IF;
            END IF;     
            
            INSERT INTO istoric_lucru 
            VALUES(t_upd(i).id_ang, t_upd(i).d_ang, SYSDATE, t_upd(i).v_cin, t_upd(i).v_job);
                
            UPDATE angajat
            SET data_ang = SYSDATE
            WHERE cod_angajat = t_upd(i).id_ang;   
            
            IF t_upd(i).v_job NOT LIKE t_upd(i).n_job THEN
                SELECT salariu_max, salariu_min INTO sal_max, sal_min
                FROM job
                WHERE cod_job LIKE t_upd(i).n_job;
                
                IF sal_max < t_upd(i).v_sal THEN
                    UPDATE angajat
                    SET salariu = sal_max
                    WHERE cod_angajat = t_upd(i).id_ang;
                ELSIF sal_min > t_upd(i).v_sal THEN
                    UPDATE angajat
                    SET salariu = sal_min
                    WHERE cod_angajat = t_upd(i).id_ang;
                END IF;
            END IF;
        END LOOP;  
    END AFTER STATEMENT;
END trig_after_proiect_ex11_rs;
/

INSERT INTO angajat
VALUES (1, 'ana', 'blandiana', 'ana.bland@gmail', null, sysdate, 59827, 8, null, 120, 'MAN');
--Error report -
--ORA-20002: Exista deja un manager in cinematograful dorit!
--ORA-06512: at "C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS", line 14
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS'

INSERT INTO angajat
VALUES (1, 'ana', 'blandiana', 'ana.bland@gmail', null, sysdate, 59827, 8, null, 120, 'AG_C');
--Error report -
--ORA-20002: Salariul este mai mare decat cel maxim pentru jobul ales!
--ORA-06512: at "C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS", line 37
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS'

UPDATE angajat
SET cod_cinema = 140
WHERE cod_angajat = 1000;
--Error report -
--ORA-20002: Exista deja un manager in cinematograful dorit!
--ORA-06512: at "C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS", line 81
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS'

UPDATE angajat
SET cod_job = 'BAR'
WHERE cod_angajat = 1000;
--1 row updated
--1 row inserted into istoric_lucru
--nu modifica id_superior pt subalternii sai 

SELECT * FROM istoric_lucru;

DELETE FROM angajat
WHERE cod_angajat = 1000;
--1 row deleted
--sterge din istoric si modifica id_duperior pt subalternii sai

SELECT * FROM istoric_lucru;

UPDATE angajat
SET cod_cinema = 200, cod_job = 'PLAS', id_superior = 1170
WHERE cod_angajat = 1272;
--1 row updated
--modificari in lant

SELECT * FROM istoric_lucru;
SELECT * FROM angajat;

UPDATE angajat
SET cod_cinema = 200, cod_job = 'PLAS', id_superior = 1000
WHERE cod_angajat = 1272;
--Error report -
--ORA-20002: Id-ul superiorului este gresit, deoarece nu exista un angajat cu acest cod in cinematograful dorit!
--ORA-06512: at "C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS", line 51
--ORA-04088: error during execution of trigger 'C##SGBD_STEF.TRIG_BEFORE_PROIECT_EX11_RS'

DROP TRIGGER trig_before_proiect_ex11_rs;
DROP TRIGGER trig_after_proiect_ex11_rs;

ROLLBACK;