CREATE TABLE RESULTS(
	AcademicYear VARCHAR(7),
	Semester VARCHAR(4) CHECK (Semester like 'SEM%' or Semester = 'Resit'),
	moduleNo VARCHAR2(6),
	studentNo NUMBER(7),
	component1Result Number(3) Not Null CHECK ((component1Result < 100) or (component1Result = 100)),
	component1Weighting Number(3) Not Null CHECK ((component1Weighting < 100) or (component1Weighting = 100)),
	component2Result Number(3) CHECK ((component2Result < 100) or (component2Result = 100)),
	component2Weighting Number(3) CHECK (component2Weighting < 100),
	overallMark Number(3) NOT NULL,
	status VARCHAR(5) NOT NULL,
	comments VARCHAR(20), 
	FOREIGN KEY (moduleNo) REFERENCES MODULE(moduleNo),
	FOREIGN KEY (studentNo) REFERENCES STUDENT(studentNo),
	Constraint Comp_key PRIMARY KEY (Semester, AcademicYear, moduleNo, studentNo)
);

CREATE TABLE RESULTACCESS(
	OLDMARK NUMBER(3),
	NEWMARK NUMBER(3),
	T_USER VARCHAR(27),
	TDATE DATE,
	STATUS VARCHAR(12),
	moduleno varchar2(6),
	STUDENTNO NUMBER(7),
	OLDCOMPONENT1 NUMBER(3),
	NEWCOMPONENT1 NUMBER(3),
	OLDCOMPONENT2 NUMBER(3),
	NEWCOMPONENT2 NUMBER(3)
);


 CREATE OR REPLACE TRIGGER DONT_CHANGE_MARKS
	BEFORE INSERT OR DELETE OR UPDATE OF OVERALLMARK, COMPONENT1RESULT, COMPONENT2RESULT ON RESULTS
	FOR EACH ROW
	DECLARE
		Overallmark_is_out_of_range EXCEPTION;
	BEGIN
		IF (:new."COMPONENT1RESULT" is not null) and (:new."COMPONENT2RESULT" is not null) then
			if :new.overallmark <> (:new.component1result * :new.component1weighting) + (:new.component2result * :new.component2weighting) then
				raise Overallmark_is_out_of_range;
			ELSIF :NEW.OVERALLMARK := (:NEW.COMPONENT1RESULT * :NEW.COMPONENT1WEIGHTING) + (:NEW.COMPONENT2RESULT * :NEW.COMPONENT2WEIGHTING) THEN 
					IF (:OLD.OVERALLMARK <> :NEW.OVERALLMARK) THEN
						INSERT INTO RESULTACCESS VALUES (:OLD.OVERALLMARK, :NEW.OVERALLMARK, SYSDATE, :NEW.STUDENTNO, :OLD.COMPONENT1RESULT, :NEW.COMPONENT1RESULT, :OLD.COMPONENT2RESULT, :NEW.COMPONENT2RESULT);
				END IF;
			end if;
		END IF;
		EXCEPTION
			WHEN Overallmark_is_out_of_range THEN
				RAISE_APPLICATION_ERROR(-20001, 'Overall mark is out of range.');	
	END;
	/
	
	UPDATE RESULTS
   SET COMPONENT1RESULT = 90, COMPONENT2RESULT = 90, OVERALLMARK = 100
    WHERE STUDENTNO = '2060221';
UPDATE RESULTS

INSERT INTO RESULTS VALUES
	('2021/22', 'SEM2', '120894', '2060221', 90, 50, 90, 50, 100, 'Pass', null);
	

CREATE OR REPLACE TRIGGER TO_ACCESS
BEFORE UPDATE OF OVERALLMARK, COMPONENT1RESULT, COMPONENT2RESULT ON RESULTS
FOR EACH ROW
BEGIN
	
    IF (:OLD.OVERALLMARK <> :NEW.OVERALLMARK) THEN
        INSERT INTO RESULTACCESS VALUES (:OLD.OVERALLMARK, :NEW.OVERALLMARK, USER, SYSDATE, 'UPDATE', :NEW.moduleno, :NEW.STUDENTNO, :OLD.COMPONENT1RESULT, :NEW.COMPONENT1RESULT, :OLD.COMPONENT2RESULT, :NEW.COMPONENT2RESULT);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER DONT_CHANGE_MARKS
BEFORE UPDATE OR INSERT OF OVERALLMARK, COMPONENT1RESULT, COMPONENT2RESULT ON RESULTS
FOR EACH ROW

BEGIN
	IF (UPDATING) THEN
		if :new.overallmark <> (:new.component1result * (:old.component1weighting / 100)) + (:new.component2result * (:old.component2weighting) / 100) then
			raise_application_error(-20001, 'Overall mark does not match component results or weightings');
		end if;
	END IF;
	if (INSERTING) THEN
		if :new.overallmark <> (:new.component1result * (:new.component1weighting / 100)) + (:new.component2result * (:new.component2weighting) / 100) then
			raise_application_error(-20001, 'Overall mark does not match component results or weightings');
		end if;
	END IF;
END;
/


CREATE OR REPLACE TRIGGER No_deletion
BEFORE DELETE ON RESULTS
FOR EACH ROW
BEGIN
	IF(USER <> 'OPS$2108418') THEN
		RAISE_APPLICATION_ERROR(-20002, 'YOU ARE NOT ALLOWED TO DELETE FROM THIS TABLE!');
	END IF;
	IF(USER = 'OPS$2108418') THEN
		INSERT INTO RESULTACCESS VALUES (:OLD.OVERALLMARK, NULL, USER, SYSDATE, 'DELETION', :OLD.moduleno, :OLD.STUDENTNO, :OLD.COMPONENT1RESULT, NULL, :OLD.COMPONENT2RESULT, NULL);
	END IF;
END;
/



 update OPS$2108418.results
   set component1result = 88
    , component2result = 80
    , overallmark = 84
    where studentno = 2001890 and moduleno = '120894';
, component2result = 50

INSERT INTO RESULTS VALUES
	('2021/22', 'SEM1', '120894', '2001890', 90, 50, 87, 50, 86, 'Pass', null);