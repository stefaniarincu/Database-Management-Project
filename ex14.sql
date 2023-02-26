--14. Definiti un pachet care sa includa tipuri de date complexe si obiecte necesare unui flux de actiuni 
--integrate, specifice bazei de date definite (minim 2 tipuri de date, minim 2 functii, minim 2 proceduri).

/*
    Procedura "colectare_date" aduna in tabelul de tip record, definit in cadrul pachetului informatii coerente, memorand date 
despre fiecare cinematograf din baza de date, colectand id-ul si numele acestuia, numele unui film care ruleaza in acel cinematograf,
numarul de rulari ce au avut loc in cinematograful actual pentru filmul actual, numarul de difuzari si numarul de bilete cumparate.
Numarul de difuzari ?i de bilete se vor afla cu ajutorul functiilor "nr_difuz?ri" si "nr_bilete".
    Procedura "afisare" va afisa datele memorate in tabelul de tip record cu ajutorul procedurii "colectare_date". Afisarea se va 
face pe categorii, listandu-se prima data cazul in care au fost memorate date complete despre cinematograf, filme, rul?ri, difuz?ri si bilete 
(cel putin o informatie completa), sau cazul in care nu avem nicio data completa memorata. De asemenea se va trata, cazul in care 
nu avem deloc date despre filme care sa fi rulat in acel cinematograf, sau ne lipsesc date despre rulari, difuzari sau bilete 
(cel putin una dintre ele are valoarea 0) pentru fiecare film care a rulat in acel cinematograf, iar atunci vom afisa continutul 
tabelului imbricat ce retine numele cinemtografelor care nu inregistreaza nici macar o informatie completa.
    Procedura "modificare" mareste salariul tuturor angajatilor care lucreaza in unul din cinematografele care au vandut maximul 
de bilete vandute (calculat de noi din baza de date). Se va verifica daca noul salariu se incadreaza in limitele salariilor pentru 
jobul pe care se afla acel angajat, cu ajutorul unei functii ("verif_sal"). Salariul se va mari cu 
num?rul maxim de bilete vandute * 0.5. De asemenea, la final se va afisa numarul de linii afectate de comanda UPDATE.
*/



CREATE OR REPLACE PACKAGE pachet_proiect_ex14_rs AS    
    --tip de date -> RECORD
    TYPE rec_pak IS RECORD
        (id_cinema cinematograf.cod_cinema%TYPE,
         n_cinema cinematograf.nume_cinema%TYPE,
         n_film film.nume_film%TYPE,
         cnt_rulat NUMBER,
         cnt_dif NUMBER,
         cnt_bilet NUMBER);
    --tip de date -> tabel imbricat ce retine obiecte de tipul RECORD definit mai sus
    TYPE tabel_auxiliar IS TABLE OF rec_pak;
    info_compl tabel_auxiliar := tabel_auxiliar();

    --tip de date -> tabel imbricat ce nume de cinemtografe
    TYPE tabel_auxiliar_2 IS TABLE OF cinematograf.nume_cinema%TYPE;
    info_err tabel_auxiliar_2 := tabel_auxiliar_2();

    --tip de date -> cursor explicit
    CURSOR c_cinema RETURN cinematograf%ROWTYPE;
    --tip de date -> cursor parametrizat
    CURSOR c_film (p_cinema cinematograf.cod_cinema%TYPE) IS
        (SELECT f.cod_film, nume_film, COUNT(*)
         FROM film f, ruleaza r
         WHERE f.cod_film = r.cod_film AND p_cinema = r.cod_cinema
         GROUP BY f.cod_film, nume_film);
   
    FUNCTION nr_bilete_cump(c_cin cinematograf.cod_cinema%TYPE, c_film film.cod_film%TYPE) 
        RETURN NUMBER;
    
    FUNCTION nr_difuzari(c_cin cinematograf.cod_cinema%TYPE, c_film film.cod_film%TYPE) 
        RETURN NUMBER;
    
    FUNCTION max_bilet RETURN NUMBER;
    
    FUNCTION verif_sal(c_job job.cod_job%TYPE, new_sal NUMBER) RETURN NUMBER;
    
    PROCEDURE colectare_date;
    
    PROCEDURE afisare;
    
    PROCEDURE modificare;
END pachet_proiect_ex14_rs;
/

CREATE OR REPLACE PACKAGE BODY pachet_proiect_ex14_rs AS    
    CURSOR c_cinema RETURN cinematograf%ROWTYPE IS 
        SELECT * 
        FROM cinematograf;
    
    FUNCTION nr_bilete_cump(c_cin cinematograf.cod_cinema%TYPE, c_film film.cod_film%TYPE) 
        RETURN NUMBER 
    IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM bilet_cumparat b, difuzare d
        WHERE b.cod_difuzare = d.cod_difuzare AND d.cod_cinema = c_cin AND d.cod_film = c_film;
        RETURN cnt;
    END nr_bilete_cump;
    
    FUNCTION nr_difuzari(c_cin cinematograf.cod_cinema%TYPE, c_film film.cod_film%TYPE) 
        RETURN NUMBER 
    IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM difuzare d
        WHERE d.cod_cinema = c_cin AND d.cod_film = c_film;
        RETURN cnt;
    END nr_difuzari;
    
    FUNCTION max_bilet 
        RETURN NUMBER 
    IS
        maxim NUMBER := -1;
    BEGIN
        IF info_compl.COUNT > 0 THEN
            FOR i IN info_compl.FIRST..info_compl.LAST LOOP
                IF maxim < info_compl(i).cnt_bilet THEN
                    maxim := info_compl(i).cnt_bilet;
                END IF;
            END LOOP;
        END IF;
        RETURN maxim;        
    END max_bilet;
    
    FUNCTION verif_sal(c_job job.cod_job%TYPE, new_sal NUMBER) 
        RETURN NUMBER
    IS
        sal_max NUMBER;
    BEGIN
        SELECT salariu_max INTO sal_max
        FROM job
        WHERE cod_job = c_job;
        
        IF sal_max > new_sal THEN
            RETURN 1;
        ELSE 
            RETURN -1;
        END IF;
    END verif_sal;
    
    PROCEDURE colectare_date
    IS
        cod_f film.cod_film%TYPE;
        nume_f film.nume_film%TYPE;
        cnt_rul NUMBER;
        cnt_bil NUMBER;
        cnt_dif NUMBER;
        contor NUMBER;
    BEGIN
        IF info_compl.COUNT = 0 AND info_err.COUNT = 0 THEN
            FOR i IN c_cinema LOOP
                OPEN c_film(i.cod_cinema);
                contor := 0;
                LOOP 
                    FETCH c_film INTO cod_f, nume_f, cnt_rul;
                    EXIT WHEN c_film%NOTFOUND;
                    cnt_dif := nr_difuzari(i.cod_cinema, cod_f);
                    cnt_bil := nr_bilete_cump(i.cod_cinema, cod_f);
                    IF cnt_rul != 0 AND cnt_dif != 0  AND cnt_bil != 0 THEN
                        info_compl.EXTEND;
                        info_compl(info_compl.COUNT).id_cinema := i.cod_cinema;
                        info_compl(info_compl.COUNT).n_cinema := i.nume_cinema;
                        info_compl(info_compl.COUNT).n_film := nume_f;
                        info_compl(info_compl.COUNT).cnt_rulat := cnt_rul;
                        info_compl(info_compl.COUNT).cnt_bilet := cnt_bil;
                        info_compl(info_compl.COUNT).cnt_dif := cnt_dif;
                    ELSE 
                        contor := contor + 1;          
                    END IF;
                END LOOP;
                IF c_film%ROWCOUNT = 0 OR c_film%ROWCOUNT = contor THEN
                    info_err.EXTEND;
                    info_err(info_err.COUNT) := i.nume_cinema;
                END IF;
                CLOSE c_film;
            END LOOP; 
        END IF;
    END colectare_date;
    
    PROCEDURE afisare
    IS
        v_prec cinematograf.cod_cinema%TYPE := -100;
    BEGIN
        IF info_compl.COUNT =0  AND info_err.COUNT = 0 THEN
            colectare_date;
        END IF;
        IF info_compl.COUNT > 0 THEN
            dbms_output.put_line('---------------DATE COMPLETE (FILM, RULARE, DIFUZARE, BILETE)-------------');
            FOR i IN info_compl.FIRST..info_compl.LAST LOOP
                IF v_prec != info_compl(i).id_cinema THEN
                    dbms_output.new_line();
                    dbms_output.put_line('--------------------------------------------------------------------------');
                    dbms_output.put_line('                    ' || UPPER(info_compl(i).n_cinema));
                    dbms_output.new_line();
                    v_prec := info_compl(i).id_cinema;
                END IF;
                dbms_output.put_line(' [Filmul ' || UPPER(info_compl(i).n_film) || '] [Nr. Rulari ' ||   info_compl(i).cnt_rulat || ' ] [Nr. Difuzari ' ||   info_compl(i).cnt_dif || ' ] [Nr. Bilete ' ||   info_compl(i).cnt_bilet || ']');
            END LOOP;
            dbms_output.new_line();
            dbms_output.put_line('--------------------------------------------------------------------------');
            dbms_output.new_line();
            dbms_output.new_line();
        ELSE 
            dbms_output.put_line('---------------NU EXISTA DATE COMPLETE (FILM, RULARE, DIFUZARE, BILETE)-----------');
            dbms_output.put_line('--------------------------------------------------------------------------');
            dbms_output.new_line();
            dbms_output.new_line();
        END IF;
        IF info_err.COUNT > 0 THEN
            dbms_output.put_line('------------------------------DATE LIPSA----------------------------------');
            dbms_output.new_line();
            FOR i IN info_err.FIRST..info_err.LAST LOOP
                    dbms_output.put_line('                    ' || UPPER(info_err(i)));
            END LOOP;
         ELSE 
            dbms_output.put_line('-------------------------NU EXISTA DATE LIPSA-----------------------------');
            dbms_output.new_line();
        END IF;
    END afisare;
    
    PROCEDURE modificare
    IS
        maxim NUMBER;
        v_prec cinematograf.cod_cinema%TYPE := -100;
        v_flag NUMBER := 0;
        ok_update NUMBER;
        contor NUMBER := 0;
    BEGIN
        IF info_compl.COUNT =0  AND info_err.COUNT = 0 THEN
            colectare_date;
        END IF;
        maxim := max_bilet;
        IF maxim != -1 THEN
            FOR i IN info_compl.FIRST..info_compl.LAST LOOP
                IF v_prec != info_compl(i).id_cinema THEN
                    v_prec := info_compl(i).id_cinema;
                    v_flag := 0;
                END IF;
                IF v_prec = info_compl(i).id_cinema AND v_flag = 0 AND info_compl(i).cnt_bilet = maxim THEN
                        FOR k IN (SELECT cod_angajat, cod_job, cod_cinema, salariu
                                  FROM angajat 
                                  WHERE cod_cinema = info_compl(i).id_cinema) LOOP
                            ok_update := verif_sal(k.cod_job, k.salariu + (maxim * 0.5));
                            IF ok_update = 1 THEN
                                UPDATE angajat
                                SET salariu = k.salariu + (maxim * 0.5)
                                WHERE cod_angajat = k.cod_angajat;
                                contor := contor + 1;
                            END IF;
                        END LOOP;
                        v_flag := 1;
                    END IF;
            END LOOP;
        END IF;
        dbms_output.new_line();
        dbms_output.new_line();
        dbms_output.put_line('-----------Linii updatate: ' || contor || ' -----------');
    END modificare;
END pachet_proiect_ex14_rs;
/

EXECUTE pachet_proiect_ex14_rs.colectare_date;
EXECUTE pachet_proiect_ex14_rs.afisare;
EXECUTE pachet_proiect_ex14_rs.modificare;
SELECT * FROM angajat;

ROLLBACK;

DROP PACKAGE pachet_proiect_ex14_rs;