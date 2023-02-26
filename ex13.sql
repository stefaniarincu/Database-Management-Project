--13. Definiti un pachet care sa contina toate obiectele definite in cadrul proiectului

---Pachet auxiliar ---> SQL dinamic pentru ALTER table, create OBJECT si create TABLE of OBJECT
CREATE OR REPLACE PACKAGE pach_aux AS
    PROCEDURE altering_film;
    PROCEDURE dropping;
END pach_aux;
/

CREATE OR REPLACE PACKAGE BODY pach_aux AS
    PROCEDURE altering_film IS
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE obj IS OBJECT(nr_premii NUMBER,part NUMBER);';
        EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE tab_imbr IS TABLE OF obj;';
        EXECUTE IMMEDIATE 'ALTER TABLE film ADD (date_membrii tab_imbr) NESTED TABLE date_membrii STORE AS tab_date_membrii';
    END altering_film;
    
    PROCEDURE dropping IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE film DROP COLUMN date_membrii';
        EXECUTE IMMEDIATE 'DROP TYPE tab_imbr';
        EXECUTE IMMEDIATE 'DROP TYPE obj';
    END dropping;
END pach_aux;
/

EXECUTE pach_aux.altering_film;

--Pachet propriu-ziu
CREATE OR REPLACE PACKAGE pachet_proiect_ex13_rs AS
    PROCEDURE proc_proiect_ex6_rs;
    
    PROCEDURE proc_proiect_ex7_rs(optiune NUMBER);
    
    FUNCTION funct_proiect_ex8_rs(gen IN film.gen_princ%TYPE, an IN CHAR) RETURN NUMBER;
    
    PROCEDURE proc_proiect_ex9_rs(an CHAR, numeA VARCHAR2);
       
END pachet_proiect_ex13_rs;
/

CREATE OR REPLACE PACKAGE BODY pachet_proiect_ex13_rs AS
    PROCEDURE proc_proiect_ex6_rs IS
        CURSOR c(parametru cinematograf.cod_cinema%TYPE) IS
                SELECT c.nume_cinema, f.nume_film, f.rating, f.an_aparitie
                FROM film f
                JOIN (SELECT DISTINCT cod_cinema, cod_film
                      FROM ruleaza) r ON r.cod_film = f.cod_film 
                JOIN (SELECT cod_cinema, nume_cinema
                      FROM cinematograf) c ON r.cod_cinema = c.cod_cinema
                WHERE c.cod_cinema = parametru
                ORDER BY c.cod_cinema, f.rating DESC, f.nume_film, f.an_aparitie;
                
        TYPE record_CF IS RECORD 
            (poz NUMBER,
             nume_cinema cinematograf.nume_cinema%TYPE,
             nume_film film.nume_film%TYPE,
             rating film.rating%TYPE,
             an_aparitie film.an_aparitie%TYPE); 
             
        TYPE tab_imb_CF IS TABLE OF record_CF;
        t_CF tab_imb_CF := tab_imb_CF();
        
        TYPE varr_cinemaC IS VARRAY(20) OF cinematograf.cod_cinema%TYPE;
        vect_cod_cin varr_cinemaC;
        
        TYPE varr_cinemaN IS VARRAY(20) OF cinematograf.nume_cinema%TYPE;
        vect_num_cin varr_cinemaN;
        
        TYPE tab_ind_cnt IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        t_cntFilm tab_ind_cnt;
        
        cnt_FilmDist NUMBER;
        v_prec film.rating%TYPE;
        v_top NUMBER := 1;
        v_cnt NUMBER := 1;
    BEGIN 
        SELECT c.cod_cinema, nume_cinema, COUNT(cod_film)
        BULK COLLECT INTO vect_cod_cin, vect_num_cin, t_cntFilm
        FROM cinematograf c, ruleaza r
        WHERE c.cod_cinema = r.cod_cinema(+)
        GROUP BY c.cod_cinema, nume_cinema; 
        
        FOR i IN vect_cod_cin.FIRST..vect_cod_cin.LAST LOOP
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            IF t_cntFilm(i) = 0 THEN
                dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' NU a rulat NICIUN film pana in prezent.');
                dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');
            ELSIF t_cntFilm(i) = 1 THEN
                dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' a rulat un singur film pana in prezent.');
                dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');   
            ELSIF t_cntFilm(i) = 2 THEN
                dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat doar 2 filme pana in prezent.');
                dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');   
            ELSE
                v_top := 1;
                v_cnt := 1;
                SELECT COUNT(f.cod_film) INTO cnt_FilmDist
                FROM film f
                JOIN (SELECT DISTINCT cod_cinema, cod_film
                      FROM ruleaza) r ON r.cod_film = f.cod_film 
                JOIN (SELECT cod_cinema, nume_cinema
                      FROM cinematograf) c ON r.cod_cinema = c.cod_cinema
                WHERE c.cod_cinema = vect_cod_cin(i)
                ORDER BY c.cod_cinema, f.rating DESC, f.nume_film, f.an_aparitie;
                IF cnt_FilmDist = 1 THEN
                    dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, dar eliminand duplicatele doar un singur film DISTINCT pana in prezent.');
                    dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');
                ELSIF cnt_FilmDist = 2 THEN
                    dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, dar dar eliminand duplicatele doar 2 filme DISTINCTE pana in prezent.');
                    dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');   
                ELSE
                    OPEN c(vect_cod_cin(i));
                    t_CF.EXTEND;
                    FETCH c INTO t_CF(v_cnt).nume_cinema, t_CF(v_cnt).nume_film, t_CF(v_cnt).rating, t_CF(v_cnt).an_aparitie;
                    t_CF(v_cnt).poz := v_top;
                    v_prec := t_CF(v_cnt).rating;
                    LOOP
                        t_CF.EXTEND;
                        v_cnt := v_cnt + 1;
                        FETCH c INTO t_CF(v_cnt).nume_cinema, t_CF(v_cnt).nume_film, t_CF(v_cnt).rating, t_CF(v_cnt).an_aparitie;
                        EXIT WHEN c%NOTFOUND;
                        IF t_CF(v_cnt).rating <> v_prec THEN
                            v_top := v_top + 1;
                        END IF;
                        EXIT WHEN v_top = 4;
                        t_CF(v_cnt).poz := v_top;
                        v_prec := t_CF(v_cnt).rating;
                    END LOOP;
                    IF v_top <> 4 THEN
                        dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, iar eliminand duplicatele ' || cnt_FilmDist || ' filme DISTINCTE, dar ratingurile nu pot determina un top 3 cele mai indragite filme.');
                        dbms_output.put_line('----NU se poate reliza un top al celor mai bine cotate 3 filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '!----');
                    ELSE
                        dbms_output.put_line('In cinematograful ' || UPPER(vect_num_cin(i)) || ' au rulat ' || t_cntFilm(i) || ' filme, iar eliminand duplicatele ' || cnt_FilmDist || ' filme DISTINCTE.');
                        dbms_output.put_line('----Top 3 cele mai bine cotate filme care au rulat in cinematograful ' || UPPER(vect_num_cin(i)) || '----');
                        v_top := 0;
                        FOR j IN t_CF.FIRST..t_CF.LAST LOOP
                            IF t_CF(j).poz <> v_top THEN
                                v_top := t_CF(j).poz;
                                dbms_output.new_line;
                                dbms_output.put_line('------LOCUL ' || v_top || ' ------');
                                dbms_output.put_line('---Ratingul: ' || t_CF(j).rating|| ' ---');
                            END IF;
                            dbms_output.put_line('Filmul: ' || t_CF(j).nume_film || ', aparut in anul: ' || t_CF(j).an_aparitie);
                        END LOOP;
                    END IF;
                    t_CF.DELETE;
                    CLOSE c;
                END IF;
            END IF;
            dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------');
            dbms_output.new_line();   
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
    END proc_proiect_ex6_rs;
    
    PROCEDURE proc_proiect_ex7_rs(optiune NUMBER) IS   
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
    
    FUNCTION funct_proiect_ex8_rs(gen IN film.gen_princ%TYPE, an IN CHAR)
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

    PROCEDURE proc_proiect_ex9_rs(an CHAR, numeA VARCHAR2) IS
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
END pachet_proiect_ex13_rs;
/

EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex6_rs;

EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex7_rs(1);
EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex7_rs(99);

DECLARE
    pret NUMBER;
BEGIN
    pret := pachet_proiect_ex13_rs.funct_proiect_ex8_rs('Teatru', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/
DECLARE
    pret NUMBER;
BEGIN
    pret := pachet_proiect_ex13_rs.funct_proiect_ex8_rs('Actiune', '2019');
    dbms_output.put_line('Suma preturilor biletelor vandute care sa respecte criteriile impuse este de:   ' || pret);
END;
/

EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex9_rs('-10', 'Zendaya');
EXECUTE pachet_proiect_ex13_rs.proc_proiect_ex9_rs('2000', 'Ryan');

EXECUTE pach_aux.dropping;
DROP PACKAGE pach_aux;
DROP PACKAGE pachet_proiect_ex13_rs;
