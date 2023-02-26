--7. Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat independent care sa utilizeze 2 tipuri 
--diferite de cursoare studiate, unul dintre acestea fiind cursor parametrizat. Apelati subprogramul

/*
    Sa se creeze o procedura care primeste ca parametru un numar ce reprezinta optiunea dorita de utilizator si afiseaza 
informatii coerente, in concordanta cu alegerea introdusa de acesta. Optiunile existente sunt 1 si 2.
    Pentru optiunea 1 se vor lista toate cinematografele existente in baza de date, impreuna cu informatii coerente despre
situatia de angajare din cadrul cinematografului respectiv, ceea ce inseamna ca se vor afisa joburile care au posturi 
ocupate, impreuna cu angajatii care lucreaza pe jobul respectiv, in acel cinematograf sau un mesaj care sa indice faptului ca 
pentru acel cinematograf nu avem inregistrat niciun angajat
    Pentru optiunea 2, se vor lista toate cinematografele existente in baza de date, precizandu-se numarul angajatilor care
lucreaza in prezent in acel cinematograf si numarul angajatilor care au lucrat in trecut in acel cinematograf. De asemenea, 
impreuna cu cinematografele se afiseaza informatii coerente despre situatia de angajare din cadrul cinematografului respectiv,
ceea ce inseamna ca se vor afisa joburile care au posturi ocupate in prezent sau care au fost ocupate in trecut si angajatii 
care lucreaza pe jobul respectiv, in acel cinematograf si/sau care au lucrat in trecut pe jobul respectiv, in acel cinematograf, 
impreuna cu un mesaj care sa precizeze ce fel de angajat este(Actual / Istoric)
    Orice alt numar reprezinta o optiune incorecta
*/

--PROCEDURA (subprogram stocat), EXPRESIE CURSOR IMRICATA, CURSOR EXPLICIT, CURSOR PARAMETRIZAT, CICLU CURSOR, 
--CICLU CURSOR CU SUBCERERI, REF CURSOR

CREATE OR REPLACE PROCEDURE proc_proiect_ex7_rs(optiune NUMBER) IS   
    --expresie cursor imbricata
    CURSOR c_expr
                IS SELECT nume_cinema, CURSOR (SELECT nume_job, CURSOR (SELECT nume || ' ' || prenume
                                                                        FROM angajat a
                                                                        WHERE a.cod_cinema = c.cod_cinema AND j.cod_job = a.cod_job)
                                               FROM job j)
                    FROM cinematograf c;
    v_nume_cinema cinematograf.nume_cinema%TYPE;
    v_nume_job job.nume_job%TYPE;
    v_nume_ang VARCHAR2(70);
    v_nr_ang NUMBER;
    cnt NUMBER;
    TYPE refcursor IS REF CURSOR;
    v_cursor_imbr refcursor;
    v_cursor refcursor;
    
    --cursor explicit
    CURSOR c_expl IS SELECT c.cod_cinema v_cod_cinema, c.nume_cinema v_nume_cinema, COUNT(a.cod_angajat) v_cnt_ang, 
                                                                            (SELECT COUNT(*)
                                                                             FROM  istoric_lucru il
                                                                             WHERE c.cod_cinema = il.cod_cinema(+))v_hist_ang
                    FROM cinematograf c, angajat a
                    WHERE c.cod_cinema = a.cod_cinema(+)
                    GROUP BY c.cod_cinema, c.nume_cinema;
    
    --cursor parametrizat
    CURSOR c_param(param_cin cinematograf.cod_cinema%TYPE, param_job job.nume_job%TYPE) 
        IS SELECT nume || ' ' || prenume
           FROM angajat a, job j
           WHERE cod_cinema = param_cin AND a.cod_job = j.cod_job AND j.nume_job = param_job;
           
    --cursor parametrizat
    CURSOR c_param_hist(param_cin cinematograf.cod_cinema%TYPE, param_job job.nume_job%TYPE) 
        IS SELECT nume || ' ' || prenume
           FROM angajat a, job j, istoric_lucru il
           WHERE il.cod_cinema = param_cin AND il.cod_job = j.cod_job 
                AND j.nume_job = param_job AND il.cod_angajat = a.cod_angajat;
BEGIN
    IF optiune = 1 THEN
        OPEN c_expr;
        LOOP
            FETCH c_expr INTO v_nume_cinema, v_cursor_imbr;
            EXIT WHEN c_expr%NOTFOUND;
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            dbms_output.put_line('Cinematograful ' || UPPER(v_nume_cinema));
            dbms_output.new_line();
            cnt := 0;
            LOOP
                FETCH v_cursor_imbr INTO v_nume_job, v_cursor;
                EXIT WHEN v_cursor_imbr%NOTFOUND;
                
                FETCH v_cursor INTO v_nume_ang;
                IF v_cursor%ROWCOUNT > 0 THEN
                    dbms_output.put_line('---------Jobul ' || UPPER(v_nume_job) || ' ---------');
                    dbms_output.put_line('     Angajatul ' || v_nume_ang);
                    LOOP 
                        FETCH v_cursor INTO v_nume_ang;
                        EXIT WHEN v_cursor%NOTFOUND;
                        dbms_output.put_line('     Angajatul ' || v_nume_ang);
                    END LOOP;
                    dbms_output.new_line();
                END IF;
                IF v_cursor%ROWCOUNT = 0 THEN
                    cnt := cnt + 1;
                END IF;
            END LOOP;
            IF v_cursor_imbr%ROWCOUNT = cnt THEN
                dbms_output.put_line('     NICIUN ANGAJAT ');
                dbms_output.new_line();
            END IF;
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
        END LOOP;
        CLOSE c_expr;
    ELSIF optiune = 2 THEN
        --ciclu cursor
        FOR k IN c_expl LOOP
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            IF k.v_cnt_ang = 0 THEN
                IF k.v_hist_ang = 0 THEN
                    dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' nu lucreaza si nu a lucrat NICIUN angajat');
                ELSIF k.v_hist_ang = 1 THEN
                    dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' nu lucreaza in prezent NICIUN angajat, insa in trecut a mai lucrat un singur angajat');
                ELSE
                    dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' nu lucreaza in prezent NICIUN angajat, insa in trecut au mai lucrat ' || k.v_hist_ang || ' angajati');
                END IF;
            ELSE
                IF k.v_cnt_ang = 1 THEN
                    IF k.v_hist_ang = 0 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent un singur angajat, iar in trecut nu a mai lucrat NICIUN angajat');
                    ELSIF k.v_hist_ang = 1 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent un singur angajat, iar in trecut a mai lucrat un singur angajat');
                    ELSE
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent un singur angajat, iar in trecut au mai lucrat ' || k.v_hist_ang || ' angajati');
                    END IF;
                ELSE 
                    IF k.v_hist_ang = 0 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent ' || k.v_cnt_ang || ' angajati, iar in trecut nu a mai lucrat NICIUN angajat');
                    ELSIF k.v_hist_ang = 1 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent ' || k.v_cnt_ang || ' angajati, iar in trecut a mai lucrat un singur angajat');
                    ELSE
                        dbms_output.put_line('In cinematograful ' || UPPER(k.v_nume_cinema) || ' lucreaza in prezent ' || k.v_cnt_ang || ' angajati, iar in trecut au mai lucrat ' || k.v_hist_ang || ' angajati');
                    END IF;
                END IF;
                --ciclu cursor cu subcereri
                FOR i IN (SELECT nume_job, (SELECT COUNT(a.cod_angajat)
                                            FROM  angajat a
                                            WHERE a.cod_job(+) = j.cod_job 
                                            AND a.cod_cinema = k.v_cod_cinema) nr_ang, 
                                           (SELECT COUNT(il.cod_angajat)
                                            FROM  istoric_lucru il
                                            WHERE j.cod_job = il.cod_job(+) 
                                            AND il.cod_cinema = k.v_cod_cinema) hist_ang
                           FROM job j) LOOP
                    IF i.nr_ang != 0 THEN
                        OPEN c_param(k.v_cod_cinema, i.nume_job);
                        dbms_output.new_line();
                        dbms_output.put_line('---------Jobul ' || UPPER(i.nume_job) || ' ---------');
                        LOOP
                            FETCH c_param INTO v_nume_ang;
                                EXIT WHEN c_param%NOTFOUND;
                                dbms_output.put_line('  (Actual)    Angajatul ' || v_nume_ang);
                            END LOOP;
                        CLOSE c_param;
                        IF i.hist_ang != 0 THEN
                            OPEN c_param_hist(k.v_cod_cinema, i.nume_job);
                            LOOP
                                FETCH c_param_hist INTO v_nume_ang;
                                    EXIT WHEN c_param_hist%NOTFOUND;
                                    dbms_output.put_line('  (Istoric)    Angajatul ' || v_nume_ang);
                            END LOOP;
                            CLOSE c_param_hist;
                        END IF;
                    ELSIF i.hist_ang != 0 THEN
                        OPEN c_param_hist(k.v_cod_cinema, i.nume_job);
                        dbms_output.new_line();
                        dbms_output.put_line('---------Jobul ' || UPPER(i.nume_job) || ' ---------');
                        LOOP
                            FETCH c_param_hist INTO v_nume_ang;
                            EXIT WHEN c_param_hist%NOTFOUND;
                            dbms_output.put_line('  (Istoric)    Angajatul ' || v_nume_ang);
                        END LOOP;
                        CLOSE c_param_hist;
                    END IF;
                END LOOP;
            END IF; 
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            dbms_output.new_line();
        END LOOP;
    ELSE
        dbms_output.put_line('Optiunea nu e valida');
    END IF;
EXCEPTION 
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');       
END proc_proiect_ex7_rs;
/

DECLARE 
    optiune NUMBER := &optiune;
BEGIN
    proc_proiect_ex7_rs(optiune);
END;
/

DROP PROCEDURE proc_proiect_ex7_rs;