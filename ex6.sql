--6. Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat independent care sa utilizeze 
--doua tipuri diferite de colectii studiate. Apelati subprogramul.

/*
    Pentru fiecare cinematograf din baza de date sa se afiseze un top al 3 celor mai bine cotate filme (criteriul de departajare si
de clasificare in acest top se va face pe baza ratingului) care au rulat in cadrul acestuia. 
    Se vor face afisari corespunzatoare si verificari pentru:
I.     cazul in care un cinematograf nu a rulat cel putin 3 filme pana in prezent
II.    cazul in care un cinematograf nu a rulat cel putin 3 filme DISTINCTE pana in prezent
III.   cazul in care un cinematograf a rulat cel putin 3 filme DISTINCTE pana in prezent, dar nu se poate realiza un top 3 deoarece 
filmele din cadrul acelui cinematograf au au ratinguri comune, ce nu permit departajarea pe cel putin 3 locuri
IV.    cazul in care un cinematograf a rulat cel putin 3 filme DISTINCTE pana in prezent si se poate realiza departajarea acestora 
pe 3 locuri distincte
*/

--PROCEDURA (subprogram stocat), TABEL IMBRICAT ce contine date de tip RECORD, VARRAY, TABEL INDEXAT

CREATE OR REPLACE PROCEDURE proc_proiect_ex6_rs IS
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
            /*
            SELECT COUNT(f.cod_film) INTO cnt_FilmDist
            FROM film f
            JOIN (SELECT DISTINCT cod_cinema, cod_film
                  FROM ruleaza) r ON r.cod_film = f.cod_film 
            JOIN (SELECT cod_cinema, nume_cinema
                  FROM cinematograf) c ON r.cod_cinema = c.cod_cinema
            WHERE c.cod_cinema = vect_cod_cin(i)        
            ORDER BY c.cod_cinema, f.rating DESC, f.nume_film, f.an_aparitie;
            */
            
            SELECT COUNT(DISTINCT cod_film) INTO cnt_FilmDist
            FROM ruleaza
            WHERE cod_cinema = vect_cod_cin(i);
            
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
                --IF v_top <> 4 THEN
                IF v_top <> 4 AND v_top <> 3 THEN
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
/ 

EXECUTE proc_proiect_ex6_rs;

DROP PROCEDURE proc_proiect_ex6_rs;