--9. Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat 
--independent de tip procedura care sa utilizeze intr-o singura comanda SQL 5 dintre tabelele 
--definite. Tratati toate exceptiile care pot aparea, incluzand exceptiile NO_DATA_FOUND si 
--TOO_MANY_ROWS. Apelati subprogramul astfel incat sa evidentiati toate cazurile tratate.

/*
    Sa se implementeze o procedura care primeste ca parametrii un an si un nume de actor. Vrem sa cautam date despre filmele 
care au rulat pe o perioada mai lung? de 4 luni intr-un cinematograf deschis luni sau sambata, tinand cont ca anul rularii 
respective sa fie mai mare decat anul dat ca parametru, si de acesmenea, acel film sa aiba inregistrata o difuzare intr-o sala
de tipul 'vip' sau care contine in numele tipului subsirul 'multi'.
    Sa se modifice structura tabelei FILM astfel incat sa se retina intr-o singura coloana date despre numarul de premii stranse 
de toti actorii din baza de date care au participat la distributia filmului respectiv, numarul acestor actori, numarul de premii
stranse de toti regizorii din baza de date care au participat la distributia filmului respectiv si numarul acestor regizori. In 
aceasta noua coloana se vor numara doar premiile actorilor si numarul actorilor care au anul de debut diferit de anul de debut
preluat de la actorul cu numele sau prenumele dat ca parametru in procedura.
    In cadrul procedurii descrise mai sus, vrem sa afisam detalii despre cinematograf, ziua deschiderii acestuia, detalii despre 
salile in care au avut loc difuzarile filmului curent, numele filmului curent si ratingul acestuia. Folosind coloana aditionala 
din tabela FILM vom calcula o medie dintre numarul de premii castigate de persoanele care fac parte din distributie si numarul 
acestor persoane, aceasta fiind media de premiere a filmului.
    Se vor trata cazurile(exceptiile) in care
I.      anul dat ca parametru este negativ
II.     anul dat ca parametru este mai mare decat cel curent
III.    pentru anul dat ca parametru nu exista cinematografe care sa se fi deschis luni sau sambata
IV.     nu exista niciun actor cu numele dat ca parametru
V.      exista mai multi actori cu numele dat ca parametru
    De asemenea, se vor afisa corespunzator mesaje pentru
I.      cazul in care media de premiere a filmului este 0
    I.1.    si avem date despre mai multi membrii care au participat in distributie
    I.2.    si avem date despre un singur membru care a participat in distributie
    I.3.    si nu avem date despre niciun membru care a participat in distributie
II.    cazul in care media de premiere a filmului este diferita de 0
    II.1.   si avem date despre mai multi membrii care au participat in distributie
    II.2.   si avem date despre un singur membru care a participat in distributie
    II.3.   si nu avem date despre niciun membru care a participat in distributie
*/

--comanda SQL ce include 5 tabele, prin intermediul subcererilor (ACTOR, JOACA, REGIZOR, REGIZEAZA, FILM)

--comanda SQL ce include 5 tabele, prin intermediul JOIN-ului (FILM, RULEAZA, DIFUZARE, CINEMATOGRAF, SALA), 
--la care se adauga prin intermediul subcererilor inca o data tabela FILM si coloana aditionala din tabela FILM preluata ca TABLE


CREATE OR REPLACE TYPE obj IS OBJECT
    (nr_premii NUMBER,
     part NUMBER);
/
CREATE OR REPLACE TYPE tab_imbr IS TABLE OF obj;
/
ALTER TABLE film
ADD (date_membrii tab_imbr) NESTED TABLE date_membrii STORE AS tab_date_membrii;

CREATE OR REPLACE PROCEDURE proc_proiect_ex9_rs(an CHAR, numeA VARCHAR2) IS
    exc_an_neg EXCEPTION;
    exc_an EXCEPTION;
    exc_an_NDF EXCEPTION;
    cnt NUMBER;
    an_deb actor.an_debut%TYPE;
BEGIN
    IF an < 0 THEN 
        RAISE exc_an_neg;
    END IF;
    IF an > TO_CHAR(SYSDATE, 'YYYY') THEN 
        RAISE exc_an;
    END IF;
    
    SELECT COUNT(*) INTO cnt
    FROM cinematograf
    WHERE to_char(data_desch, 'YYYY') >= an AND (UPPER(to_char(data_desch, 'DAY')) LIKE '%MONDAY%' 
                OR UPPER(to_char(data_desch, 'DAY')) LIKE '%SATURDAY%');
    IF cnt = 0 THEN
        RAISE exc_an_NDF;
    END IF;
    
    SELECT an_debut INTO an_deb
    FROM actor
    WHERE (LOWER(prenume) LIKE LOWER(numeA) OR LOWER(nume) LIKE LOWER(numeA));
    
    --comanda SQL ce include 5 tabele, prin intermediul subcererilor (ACTOR, JOACA, REGIZOR, REGIZEAZA, FILM)
    FOR i IN (SELECT f.cod_film cod, NVL((SELECT SUM(nr_premii)
                                          FROM actor a, joaca j
                                          WHERE a.id_actor = j.id_actor AND j.cod_film = f.cod_film
                                                AND a.an_debut <> an_deb), 0) premii_act,
                                NVL((SELECT COUNT(a.id_actor)
                                 FROM actor a, joaca j
                                 WHERE a.id_actor = j.id_actor AND j.cod_film = f.cod_film
                                       AND a.an_debut <> an_deb), 0) nr_act,
                            NVL((SELECT SUM(nr_premii)
                                 FROM regizor r, regizeaza ra
                                 WHERE r.id_regizor = ra.id_regizor AND ra.cod_film = f.cod_film), 0) premii_reg,
                        NVL((SELECT COUNT(nr_premii)
                         FROM regizor r, regizeaza ra
                         WHERE r.id_regizor = ra.id_regizor AND ra.cod_film = f.cod_film), 0) nr_reg
                FROM film f) LOOP
         UPDATE film
         SET date_membrii = tab_imbr( obj(i.premii_act, i.nr_act), obj(i.premii_reg, i.nr_reg))
         WHERE cod_film = i.cod;
    END LOOP;
    
    --comanda SQL ce include 5 tabele, prin intermediul JOIN-ului (FILM, RULEAZA, DIFUZARE,   CINEMATOGRAF, SALA), la care se 
    --adauga prin intermediul subcererilor inca o data tabela FILM si coloana aditionala din tabela film preluata ca TABLE
    FOR i IN (SELECT c.nume_cinema numeC, to_char(data_desch, 'DAY') zi,  f.nume_film numeF, d.nr_sala salaD, 
                s.tip salaT, f.rating ratingF,
                    (SELECT SUM(b.part)
                     FROM film a, TABLE (a.date_membrii) b
                     WHERE a.cod_film = f.cod_film) nr_part,
                    (SELECT SUM(b.nr_premii)
                     FROM film a, TABLE (a.date_membrii) b
                     WHERE a.cod_film = f.cod_film) nr_premii,
                    (SELECT nvl(SUM(b.nr_premii)/ NULLIF(SUM(b.part), 0), 0) 
                     FROM film a, TABLE (a.date_membrii) b
                     WHERE a.cod_film = f.cod_film) medie_premii      
                FROM film f, ruleaza r, difuzare d, cinematograf c, sala s
                WHERE c.cod_cinema = r.cod_cinema AND r.cod_film = f.cod_film
                   AND (UPPER(to_char(data_desch, 'DAY')) LIKE '%MONDAY%' OR UPPER(to_char(data_desch, 'DAY')) LIKE '%SATURDAY%')
                   AND to_char(data_desch, 'YYYY') >= an
                   AND f.cod_film = d.cod_film 
                   AND d.nr_sala = s.nr_sala AND s.cod_cinema = c.cod_cinema
                   AND (LOWER(s.tip) LIKE '%multi%' OR LOWER(s.tip) LIKE 'vip')
                   AND months_between(r.data_final, r.data_inceput) > 4
               ORDER BY 7 DESC, 6 DESC, 5 DESC, 4 DESC) LOOP
        IF UPPER(i.zi) LIKE '%SATURDAY%' THEN
            i.zi := 'SAMBATA';
        ELSE 
            i.zi := 'LUNI';
        END IF;
        dbms_output.new_line();
        IF i.medie_premii = 0 THEN
            IF i.nr_part = 1  THEN
                dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                dbms_output.put_line('Despre film se stie ca a avut ca a avut un singur membriu in productie, iar acesta nu a castigat NICIUN premiu');
            ELSIF i.nr_part > 0 THEN
                dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                dbms_output.put_line('Despre film se stie ca a avut ca a avut ' || i.nr_part || ' membrii in productie, iar acestia nu a castigat NICIUN premiu');
            ELSE 
                dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                dbms_output.put_line('Pentru acest film nu s-au putut colectiona date despre actori sau regizori');
            END IF;
        ELSE
            IF i.nr_premii = 1 THEN
                IF i.nr_part = 1 THEN
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut un singur membru in productie, iar acesta a castigat in total un singur premiu');
                    dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                ELSE
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut ' || i.nr_part 
                                    || ' membrii in productie, iar acestia au castigat in total un singur premiu');
                    dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                END IF;
            ELSE
                IF i.nr_part = 1 THEN
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut un singur membru in productie, iar acesta a castigat in total ' || i.nr_premii || ' premii');
                    dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                ELSE
                    dbms_output.put_line('[Cinematograf: ' || UPPER(i.numeC) || '] [Zi deschidere: ' || i.zi 
                                || '] [Tip sala difuzare: ' || i.salaT || '] [Numar sala difuzare: ' || i.salaD 
                                || '] [Film: ' || UPPER(i.numeF)|| '] [Rating: ' || i.ratingF || ']');
                    dbms_output.put_line('Despre film se stie ca a avut ca a avut ' || i.nr_part || ' membrii in productie, iar acestia au castigat in total ' || i.nr_premii || ' premii');
                    dbms_output.put_line('-------- Media de premiere a filmului -------> ' || i.medie_premii);
                END IF;
            END IF;
        END IF;
    END LOOP;        
EXCEPTION
    WHEN exc_an_neg THEN
        RAISE_APPLICATION_ERROR(-20003, 'Nu puteti introduce un an negativ!');
    WHEN exc_an THEN
        RAISE_APPLICATION_ERROR(-20004, 'Ati introdus un an mai mare decat anul curent, si nu exista date despre cinematografe deschise in viitor!');
    WHEN exc_an_NDF THEN
        RAISE_APPLICATION_ERROR(-20005, 'Nu exista niciun cinematograf deschis luni sau sambata, dupa anul ' || an || '!');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'Nu exista niciun actor cu numele sau prenumele ' || UPPER(numeA) || '!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20007, 'Exista mai muti actori cu numele sau prenumele ' || UPPER(numeA) || '!');
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20008, 'Alta eroare!');
END proc_proiect_ex9_rs;
/

EXECUTE proc_proiect_ex9_rs('2000', 'Ryan');
--afisare

SELECT * FROM FILM;

EXECUTE proc_proiect_ex9_rs('-10', 'Zendaya');
--ORA-20003: Nu puteti introduce un an negativ!

EXECUTE proc_proiect_ex9_rs('2033', 'Zendaya');
--ORA-20004: Ati introdus un an mai mare decat anul curent, si nu exista date despre cinematografe deschise in viitor!

EXECUTE proc_proiect_ex9_rs('2000', 'Gigi');
--ORA-20006: Nu exista niciun actor cu numele sau prenumele GIGI!

EXECUTE proc_proiect_ex9_rs('2000', 'Robert');
--ORA-20007: Exista mai muti actori cu numele sau prenumele ROBERT!

EXECUTE proc_proiect_ex9_rs('scara', 'Ryan');
--ORA-20008: Alta eroare!

ALTER TABLE film
DROP COLUMN date_membrii;

DROP TYPE tab_imbr;
DROP TYPE obj;

DROP PROCEDURE proc_proiect_ex9_rs;