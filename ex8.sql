--8. Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat
--independent de tip functie care sa utilizeze intr-o singura comanda SQL 3 dintre tabelele definite. 
--Definiti minim 2 exceptii. Apelati subprogramul astfel incat sa evidentiati toate cazurile tratate.

/*
    Fiind dat genul unui film si un an sa se afiseze suma preturilor tuturor biletelor cumparate pentru filmele care se incadreaza
in genul respectiv si pe baza carora s-a intrat la difuzari ce au avut ca data de inceput un an mai mare decat anul dat ca parametru
    Se vor trata exceptiile:
I.      anul dat ca parametru este negativ
II.     anul dat ca parametru este mai mare decat cel curent
III.    pentru genul dat ca parametru nu exista filme in baza de date
IV.     nu exista nicio difuzare pentru niciun film cu genul dat ca parametru care sa aiba loc dupa anul dat ca parametru
V.      nu exista niciun bilet cumparat la vreo difuzare ce a avut loc dupa anul dat ca parametru a vreunui film ce are genul dat ca parametru
*/

--JOIN ce include 3 tabele (FILM, DIFUZARE, BILET_CUMPARAT)

CREATE OR REPLACE FUNCTION funct_proiect_ex8_rs(gen IN film.gen_princ%TYPE, an IN CHAR)
        RETURN NUMBER IS
    exc_err_an_neg EXCEPTION;
    exc_err_an EXCEPTION;
    exc_err_gen EXCEPTION;
    exc_err_dif EXCEPTION;
    exc_err_bilet EXCEPTION;
    cnt NUMBER;
    pret NUMBER;
BEGIN
    IF an < 0 THEN 
        RAISE exc_err_an_neg;
    END IF;
    IF an > TO_CHAR(SYSDATE, 'YYYY') THEN 
        RAISE exc_err_an;
    END IF;
    SELECT COUNT(*) INTO cnt
    FROM film
    WHERE UPPER(gen_princ) = UPPER(gen);
    IF cnt = 0 THEN
        RAISE exc_err_gen;
    END IF;
    SELECT COUNT(cod_difuzare) INTO cnt
    FROM film f, difuzare d
    WHERE UPPER(gen_princ) = UPPER(gen) AND f.cod_film = d.cod_film AND TO_CHAR(data_inc, 'YYYY') >= an;
    IF cnt = 0 THEN
        RAISE exc_err_dif;
    END IF;
    --JOIN ce include 3 tabele (FILM, DIFUZARE, BILET_CUMPARAT)
    SELECT SUM(bc.pret) INTO pret
    FROM film f, difuzare d, bilet_cumparat bc
    WHERE UPPER(f.gen_princ) = UPPER(gen) AND f.cod_film = d.cod_film 
         AND bc.cod_difuzare(+) = d.cod_difuzare AND TO_CHAR(d.data_inc, 'YYYY') >= an;
    IF pret is null THEN
        RAISE exc_err_bilet;
    END IF;
    RETURN pret;
EXCEPTION
    WHEN exc_err_an_neg THEN
        RAISE_APPLICATION_ERROR(-20003, 'Nu puteti introduce un an negativ!');
    WHEN exc_err_an THEN
        RAISE_APPLICATION_ERROR(-20004, 'Ati introdus un an mai mare decat anul curent, si nu exista date despre difuzari din viitor!');
    WHEN exc_err_gen THEN
        RAISE_APPLICATION_ERROR(-20005, 'Nu exista niciun film care sa aiba genul ' || UPPER(gen) || '!');
    WHEN exc_err_dif THEN
        RAISE_APPLICATION_ERROR(-20006, 'Nu exista nicio difuzare pentru filme de genul ' || UPPER(gen) || ' care sa fi avut loc dupa anul ' || an || '!');
    WHEN exc_err_bilet THEN
        RAISE_APPLICATION_ERROR(-20007, 'Nu exista niciun bilet vandut la difuzare care a avut loc dupa anul ' || an || ' a vreunui film cu genul ' || UPPER(gen) || '!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END funct_proiect_ex8_rs;
/

--gen = actiune 
--an = 2019
SET SERVEROUTPUT ON
ACCEPT p_gen PROMPT 'Introduceti genul filmului: '
ACCEPT p_an PROMPT 'Introduceti anul: '
DECLARE
    gen film.gen_princ%TYPE := '&p_gen';
    an NUMBER := &p_an;
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs(gen, an);
    dbms_output.put_line('Suma preturilor biletelor cumparate pentru difuzari de dupa anul ' || an || ' ale filmelor ce au genul ' || UPPER(gen) || ' este de:   ' || pret);
END;
/
SET SERVEROUTPUT OFF
--Suma preturilor biletelor cumparate pentru difuzari de dupa anul 2019 ale filmelor ce au genul ACTIUNE este de:   79.7

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Actiune', '2024');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20004: Ati introdus un an mai mare decat anul curent, si nu exista date despre difuzari din viitor!

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Teatru', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20005: Nu exista niciun film care sa aiba genul TEATRU!

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Romance', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20006: Nu exista nicio difuzare pentru filme de genul ROMANCE care sa fi avut loc dupa anul 2019!

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Romance', 'scara');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20002: Alta eroare

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Comedie', '-2022');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20003: Nu puteti introduce un an negativ!

DECLARE
    pret NUMBER;
BEGIN
    pret := funct_proiect_ex8_rs('Animatie', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
--ORA-20007: Nu exista niciun bilet vandut la difuzare care a avut loc dupa anul 2019 a vreunui film cu genul ANIMATIE!

DROP FUNCTION funct_proiect_ex8_rs;
